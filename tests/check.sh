#!/usr/bin/env bash
# Runs inside a test VM as the target user. Prints PASS/FAIL per check, exits 1 on any FAIL.
set -uo pipefail

if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi
if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
    set +u
    . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    set -u
fi
export PATH="$HOME/.nix-profile/bin:$PATH"

. /etc/os-release
OS_ID=$ID
failure_count=0

check() {
    local name=$1 reason
    if reason=$("$name" 2>&1); then
        echo "PASS $name"
    else
        echo "FAIL $name: ${reason:-failed}" | head -5
        failure_count=$((failure_count + 1))
    fi
}

links_into_dotfiles() {
    local path resolved
    for path in "$@"; do
        resolved=$(readlink -f "$path") || { echo "$path missing"; return 1; }
        case "$resolved" in
            "$HOME/.dotfiles/"*) ;;
            *) echo "$path -> $resolved"; return 1 ;;
        esac
    done
}

# First interactive shell installs zinit plugins; judge the second one.
# Without a tty zsh warns "can't change option: zle"; that line is not a config error.
zsh_starts() {
    zsh -i -c 'exit 0' >/dev/null 2>&1 </dev/null || true
    local stderr_output
    stderr_output=$(zsh -i -c 'exit 0' 2>&1 >/dev/null </dev/null) || { echo "exit $?: $stderr_output"; return 1; }
    stderr_output=$(grep -v "can't change option: zle" <<<"$stderr_output")
    [ -z "$stderr_output" ] || { echo "$stderr_output"; return 1; }
}

stow_links() {
    links_into_dotfiles ~/.zshrc ~/.tmux.conf ~/.gitconfig ~/.config/nvim/init.lua ~/.config/bat/config
}

# Config errors only: headless +qa interrupts async parser/Mason installs, whose noise is not a config fault.
nvim_starts() {
    local output
    output=$(nvim --headless "+Lazy! restore" +qa 2>&1) || { echo "exit $?: $output"; return 1; }
    if grep -qE "Failed to load|Error detected while processing|Error in .*init\.lua|E5113" <<<"$output"; then
        grep -m3 -E -A2 "Failed to load|Error detected while processing|Error in .*init\.lua|E5113" <<<"$output"
        return 1
    fi
}

docker_works() {
    docker info >/dev/null
}

hm_generation() {
    [ -n "$(home-manager generations 2>/dev/null)" ] || { echo "no home-manager generations"; return 1; }
}

nvim_profile_server() {
    local profile
    profile=$(zsh -i -c 'printf "\nNVIM_PROFILE=%s" "$NVIM_PROFILE"' 2>/dev/null </dev/null | sed -n 's/^NVIM_PROFILE=//p')
    [ "$profile" = "server" ] || { echo "NVIM_PROFILE='$profile'"; return 1; }
}

no_mason() {
    [ ! -e ~/.local/share/nvim/mason ] || { echo "mason data dir exists"; return 1; }
}

# lazy.nvim rewrites its lockfile without disabled plugins; servers must not dirty the repo's copy.
repo_lock_clean() {
    git -C "$HOME/.dotfiles" diff --quiet -- nvim/.config/nvim/lazy-lock.json ||
        { git -C "$HOME/.dotfiles" diff --stat -- nvim/.config/nvim/lazy-lock.json; return 1; }
}

no_dev_plugins() {
    local plugin found=""
    for plugin in mason.nvim nvim-cmp conform.nvim nvim-lint LuaSnip outline.nvim eagle.nvim \
        glance.nvim symbol-usage.nvim trouble.nvim tiny-code-action.nvim; do
        [ -e ~/.local/share/nvim/lazy/"$plugin" ] && found="$found $plugin"
    done
    [ -z "$found" ] || { echo "installed:$found"; return 1; }
}

check zsh_starts
check stow_links
check nvim_starts
check docker_works

case "$OS_ID" in
    ubuntu|fedora)
        check hm_generation
        check nvim_profile_server
        check no_mason
        check no_dev_plugins
        check repo_lock_clean
        ;;
    nixos)
        # Filled in by the NixOS checks (plan Task 6).
        ;;
    *)
        echo "FAIL os: unsupported ID=$OS_ID"
        failure_count=$((failure_count + 1))
        ;;
esac

echo "$failure_count failure(s)"
[ "$failure_count" -eq 0 ]
