#!/usr/bin/env bash
# Boots throwaway VMs, deploys this working tree with bootstrap.sh, runs tests/check.sh inside.
# Usage: tests/vm.sh {build|ubuntu|fedora|nixos|all}
set -euo pipefail

REPO_ROOT=$(cd "$(dirname "$0")/.." && pwd)
FLAKE_DIR="$REPO_ROOT/home-manager/.config/home-manager"
CACHE_DIR=${DOTFILES_VM_CACHE:-$HOME/.cache/dotfiles-vm-tests}
LOG_DIR="$CACHE_DIR/logs"
KEY_FILE="$CACHE_DIR/id_ed25519"
SSH_WAIT_SECONDS=300
VM_USER=tdo

declare -A IMAGE_URLS=(
    [ubuntu]="https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
    [fedora]="https://download.fedoraproject.org/pub/fedora/linux/releases/43/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-43-1.6.x86_64.qcow2"
)
declare -A SSH_PORTS=([ubuntu]=2221 [fedora]=2222 [nixos]=2223)

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
info() { echo -e "${GREEN}[vm]${NC} $1"; }
fail() { echo -e "${RED}[vm]${NC} $1" >&2; return 1; }

QEMU_PID=""
VM_PORT=""
stop_vm() {
    if [ -n "$QEMU_PID" ]; then
        kill "$QEMU_PID" 2>/dev/null || true
        wait "$QEMU_PID" 2>/dev/null || true
        QEMU_PID=""
    fi
}
on_exit() {
    if [ "${VM_KEEP:-0}" = 1 ] && [ -n "$QEMU_PID" ]; then
        info "VM kept (pid $QEMU_PID): ssh -i $KEY_FILE -p $VM_PORT $VM_USER@127.0.0.1"
    else
        stop_vm
    fi
}
trap on_exit EXIT

ensure_key() {
    mkdir -p "$CACHE_DIR" "$LOG_DIR"
    [ -f "$KEY_FILE" ] || ssh-keygen -q -t ed25519 -N '' -C vm-test -f "$KEY_FILE"
}

vm_ssh() {
    local port=$1
    shift
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR \
        -o ConnectTimeout=5 -i "$KEY_FILE" -p "$port" "$VM_USER@127.0.0.1" "$@"
}

wait_for_ssh() {
    local port=$1
    local deadline_seconds=$((SECONDS + SSH_WAIT_SECONDS))
    until vm_ssh "$port" true 2>/dev/null; do
        [ "$SECONDS" -lt "$deadline_seconds" ] || fail "no SSH on port $port after ${SSH_WAIT_SECONDS}s"
        sleep 5
    done
}

# Tracked + untracked-but-not-ignored files, so uncommitted work is tested too.
snapshot_repo() {
    local tarball=$1
    (cd "$REPO_ROOT" && git ls-files -co --exclude-standard -z |
        tar --null --ignore-failed-read -T - -czf "$tarball")
}

# Recreates ~/.dotfiles in the guest as a standalone repo (a worktree's .git is only a pointer file).
UNPACK_SNAPSHOT='rm -rf ~/.dotfiles && mkdir ~/.dotfiles && tar -xzf - -C ~/.dotfiles &&
    cd ~/.dotfiles && git init -q && git add -A &&
    git -c user.name=vm-test -c user.email=vm@test commit -qm snapshot &&
    git remote add origin https://github.com/csessh/.dotfiles.git'

run_bootstrap() {
    local os=$1 port=$2 round=$3
    local log="$LOG_DIR/$os-bootstrap-$round.log"
    info "$os: bootstrap.sh round $round (log: $log)"
    if ! vm_ssh "$port" .dotfiles/bootstrap.sh </dev/null >"$log" 2>&1; then
        tail -20 "$log"
        fail "$os: bootstrap.sh round $round failed"
    fi
}

# Two rounds: a fresh install, then a re-run over the result (existing hosts re-run bootstrap).
deploy_and_check() {
    local os=$1 port=$2 tarball=$3 round check_failures=0
    info "$os: deploying snapshot"
    vm_ssh "$port" "$UNPACK_SNAPSHOT" <"$tarball"
    vm_ssh "$port" 'mkdir -p ~/.config && echo desktop > ~/.config/host-type'

    for round in 1 2; do
        run_bootstrap "$os" "$port" "$round"
        info "$os: check.sh round $round"
        vm_ssh "$port" .dotfiles/tests/check.sh || check_failures=$((check_failures + 1))
    done

    # Day-to-day update on a server: the default ${USER} config must stay server-only.
    if [ "$os" != nixos ]; then
        info "$os: home-manager switch --impure, then check.sh"
        vm_ssh "$port" '. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh &&
            PATH="$HOME/.nix-profile/bin:$PATH" home-manager switch --impure' \
            >"$LOG_DIR/$os-hm-switch.log" 2>&1 || fail "$os: home-manager switch failed"
        vm_ssh "$port" .dotfiles/tests/check.sh || check_failures=$((check_failures + 1))
    fi

    [ "$check_failures" -eq 0 ] || fail "$os: check.sh failed in $check_failures round(s)"
}

stage_build() {
    info "build: homeConfigurations.linux-server"
    nix build --no-link --impure "$FLAKE_DIR#homeConfigurations.linux-server.activationPackage"
    info "build: nixosConfigurations.fw13"
    nix build --no-link "$FLAKE_DIR#nixosConfigurations.fw13.config.system.build.toplevel"
}

stage_cloud() {
    local os=$1
    local port=${SSH_PORTS[$os]}
    local image="$CACHE_DIR/$os-base.qcow2"
    local overlay="$CACHE_DIR/$os-overlay.qcow2"
    local seed_dir="$CACHE_DIR/$os-seed"
    local tarball="$CACHE_DIR/dotfiles.tar.gz"
    ensure_key

    if [ ! -f "$image" ]; then
        info "$os: downloading base image"
        curl -fL --retry 3 -o "$image.part" "${IMAGE_URLS[$os]}"
        mv "$image.part" "$image"
    fi
    rm -f "$overlay"
    qemu-img create -q -f qcow2 -F qcow2 -b "$image" "$overlay" 20G

    rm -rf "$seed_dir"
    mkdir -p "$seed_dir"
    sed "s|@PUBKEY@|$(cat "$KEY_FILE.pub")|" "$REPO_ROOT/tests/cloud-init/user-data" >"$seed_dir/user-data"
    printf 'instance-id: %s-test\nlocal-hostname: %s-test\n' "$os" "$os" >"$seed_dir/meta-data"
    nix shell --inputs-from "$FLAKE_DIR" nixpkgs#cloud-utils -c \
        cloud-localds "$seed_dir/seed.iso" "$seed_dir/user-data" "$seed_dir/meta-data"

    info "$os: booting (serial log: $LOG_DIR/$os.log)"
    qemu-system-x86_64 -enable-kvm -cpu host -m 4096 -smp 4 -display none \
        -drive "file=$overlay,if=virtio,format=qcow2" \
        -drive "file=$seed_dir/seed.iso,if=virtio,format=raw" \
        -netdev "user,id=net0,hostfwd=tcp:127.0.0.1:$port-:22" -device virtio-net-pci,netdev=net0 \
        -serial "file:$LOG_DIR/$os.log" &
    QEMU_PID=$!
    VM_PORT=$port

    wait_for_ssh "$port"
    vm_ssh "$port" 'cloud-init status --wait' >/dev/null || true
    snapshot_repo "$tarball"
    deploy_and_check "$os" "$port" "$tarball"
    stop_vm
    info "$os: passed"
}

# build-vm shares the host /nix/store; SHARED_DIR appears in the guest as /tmp/shared.
stage_nixos() {
    local port=${SSH_PORTS[nixos]}
    local vm_link="$CACHE_DIR/nixos-vm"
    local shared_dir="$CACHE_DIR/nixos-shared"
    local disk_image="$CACHE_DIR/nixos.qcow2"
    ensure_key

    info "nixos: building VM"
    nix build --out-link "$vm_link" "$FLAKE_DIR#nixosConfigurations.fw13.config.system.build.vm"
    rm -rf "$shared_dir" "$disk_image"
    mkdir -p "$shared_dir"
    cp "$KEY_FILE.pub" "$shared_dir/authorized_keys"

    info "nixos: booting (console log: $LOG_DIR/nixos.log)"
    SHARED_DIR="$shared_dir" NIX_DISK_IMAGE="$disk_image" \
        QEMU_NET_OPTS="hostfwd=tcp:127.0.0.1:$port-:22" QEMU_OPTS="-display none" \
        "$vm_link/bin/run-fw13-vm" >"$LOG_DIR/nixos.log" 2>&1 &
    QEMU_PID=$!
    VM_PORT=$port

    wait_for_ssh "$port"
    local system_state
    system_state=$(vm_ssh "$port" 'systemctl is-system-running --wait' || true)
    info "nixos: system state: $system_state"
    if [ "$system_state" = degraded ]; then
        vm_ssh "$port" 'systemctl --failed --no-legend' || true
    fi
    case "$system_state" in
        running | degraded) ;;
        *) fail "nixos: unexpected system state '$system_state'" ;;
    esac
    snapshot_repo "$CACHE_DIR/dotfiles.tar.gz"
    deploy_and_check nixos "$port" "$CACHE_DIR/dotfiles.tar.gz"
    stop_vm
    info "nixos: passed"
}

run_stage() {
    case "$1" in
        build) stage_build ;;
        ubuntu | fedora) stage_cloud "$1" ;;
        nixos) stage_nixos ;;
    esac
}

case "${1:-}" in
    build | ubuntu | fedora | nixos) run_stage "$1" ;;
    # Fedora is opt-in (tests/vm.sh fedora); assumed equivalent to Ubuntu.
    all) for stage in build ubuntu nixos; do run_stage "$stage"; done ;;
    *)
        echo "Usage: $0 {build|ubuntu|fedora|nixos|all}" >&2
        exit 2
        ;;
esac
