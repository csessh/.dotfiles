# NixOS Workstation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Declare the `fw13` workstation as a NixOS system in this repo, trim `bootstrap.sh` to servers + NixOS user steps, give servers an LSP-free nvim, and prove all of it in NixOS/Ubuntu/Fedora VMs.

**Architecture:** One flake (`home-manager/.config/home-manager/flake.nix`) exports server `homeConfigurations` (standalone home-manager) and `nixosConfigurations.fw13` (home-manager as a NixOS module). Stow keeps deploying configs on every host; `bootstrap.sh` does system work on Fedora/Ubuntu and only user-level steps on NixOS. `tests/vm.sh` boots real qemu VMs and runs the shared `tests/check.sh` inside each.

**Tech Stack:** Nix flakes, NixOS (nixpkgs `nixos-unstable`, release 26.11), home-manager, nixos-hardware, GNU Stow, bash, qemu/KVM, cloud-init (`cloud-localds` from `nixpkgs#cloud-utils`), lazy.nvim, Mason.

**Spec:** `docs/superpowers/specs/2026-11-24-nixos-workstation-design.md`

## Global Constraints

- Work only in the worktree `/home/csessh/.dotfiles-worktrees/exp-nixos` (branch `exp/nixos`). Never edit, checkout or stow in `~/.dotfiles` — it is live-stowed on the Fedora laptop.
- Never run `stow` from the worktree and never run `home-manager switch` or `nixos-rebuild switch` on the host. Builds use `nix build`; activation happens only inside VMs.
- Nix flakes only see git-tracked files: `git add` new files before any `nix build`/`nix eval`.
- Shared files must keep working on Fedora/Ubuntu servers: `flake.nix`, `home.nix`, `packages.nix`, every Stow package, `bootstrap.sh`.
- `nixosConfigurations.fw13` must evaluate without `--impure`.
- No secrets or per-device material in git (fingerprints, SSH keys, VM test keys).
- User `csessh`, hostname `fw13`, timezone `Asia/Ho_Chi_Minh`, locale `en_AU.UTF-8` (plus `en_US.UTF-8`, which `bootstrap.sh` exports as `LC_ALL`), console keymap `us`, xkb layout `au`.
- `system.stateVersion = "26.11"` (the pinned nixpkgs `lib.trivial.release`).
- Commit messages end with `Claude-Session: https://claude.ai/code/session_01CNaQCi3d2MSrEP8a6LgfG6`.

## Review Focus

1. **Re-running the new `bootstrap.sh` on an existing server** (has `~/.config/host-type`, already-stowed configs) must succeed and leave a server profile. Test: Task 2 runs bootstrap twice and plants a stale `host-type` file first.
2. **`nvim` started without `NVIM_PROFILE`** (e.g. `sudo nvim`, a server before home-manager ran) must load the full config, not crash. Test: Task 4 local check with the variable unset.
3. **aarch64 servers** must still evaluate after the flake cleanup. Test: Task 3 evaluates `linux-arm-server`.
4. **Day-to-day `home-manager switch --impure` on a server** (the `${USER}` default config) must stay server-only. Test: Task 4 runs it in the Ubuntu VM and re-checks `NVIM_PROFILE`.
5. **Re-running `bootstrap.sh` on NixOS** must be idempotent. Test: Task 6 runs it twice.

---

### Task 1: Server VM harness and bootstrap testability fixes

**Files:**
- Create: `tests/vm.sh`, `tests/check.sh`, `tests/cloud-init/user-data`
- Modify: `bootstrap.sh` (`install_nix`, `setup_shell`, `set_default_shell`)

**Interfaces:**
- Produces: `tests/vm.sh {build|ubuntu|fedora|nixos|all}` — exit 0 only if every selected stage passes. `nixos` is a stub that prints `not implemented` and exits 1 until Task 5.
- Produces: `tests/check.sh` — run inside a VM as `csessh` from `~/.dotfiles`; prints `PASS <name>` / `FAIL <name>: <reason>` per check, exits 1 if any FAIL. Detects OS from `/etc/os-release` `ID` (`ubuntu`, `fedora`, `nixos`).
- Produces: cache dir `${DOTFILES_VM_CACHE:-$HOME/.cache/dotfiles-vm-tests}` holding images, overlays, the throwaway key `id_ed25519`, and `logs/<os>.log`.

- [ ] **Step 1: Write `tests/check.sh` with the common and server checks**

Common (all OSes):
- `zsh_starts`: `zsh -i -c exit` exits 0 with empty stderr.
- `stow_links`: `readlink -f` of each of `~/.zshrc ~/.tmux.conf ~/.gitconfig ~/.config/nvim/init.lua ~/.config/bat/config` starts with `$HOME/.dotfiles/` (works whether Stow folded the directory or linked the file).
- `nvim_starts`: `nvim --headless "+Lazy! sync" +qa` exits 0 and prints no `Error`.
- `docker_works`: `docker info` exits 0 as the user (new SSH login, so group membership applies).

Server only (ubuntu, fedora):
- `hm_generation`: `home-manager generations` prints at least one line.
- `nvim_profile_server`: `zsh -i -c 'echo $NVIM_PROFILE'` prints `server`.
- `no_mason`: after `nvim_starts`, `~/.local/share/nvim/mason` does not exist.
- `no_dev_plugins`: none of these exist under `~/.local/share/nvim/lazy/`: `mason.nvim nvim-cmp conform.nvim nvim-lint LuaSnip outline.nvim eagle.nvim glance.nvim symbol-usage.nvim trouble.nvim tiny-code-action.nvim`.

Leave a clearly marked `nixos)` branch that Task 6 fills.

- [ ] **Step 2: Write `tests/cloud-init/user-data`**

`#cloud-config` with: user `csessh`, `sudo: ALL=(ALL) NOPASSWD:ALL`, `shell: /bin/bash`, `lock_passwd: true`, `ssh_authorized_keys: [ "@PUBKEY@" ]` (vm.sh substitutes), `growpart`/`resize_rootfs` enabled.

- [ ] **Step 3: Write `tests/vm.sh` stages `build`, `ubuntu`, `fedora`**

- `build`: `nix build --no-link --impure` of `home-manager/.config/home-manager#homeConfigurations.linux-server.activationPackage`. (Task 5 adds the NixOS toplevel.)
- Images (download once into the cache dir):
  - ubuntu: `https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img`
  - fedora: `https://download.fedoraproject.org/pub/fedora/linux/releases/43/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-43-1.6.x86_64.qcow2`
- Per run: fresh qcow2 overlay backed by the image, resized to 20G; seed ISO from `nix run nixpkgs#cloud-utils -- ...` (`cloud-localds`); key from `ssh-keygen -t ed25519 -N ''` if missing.
- qemu: `-enable-kvm -m 4096 -smp 4 -display none`, virtio disk + seed, `-netdev user,hostfwd=tcp::<port>-:22`; ports ubuntu `2221`, fedora `2222`, nixos `2223`. Run in background, record PID, `trap` kills it on exit; serial console to `logs/<os>.log`.
- `wait_for_ssh`: retry `ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i <key> -p <port> csessh@127.0.0.1 true` every 5 s, give up after 300 s.
- Repo snapshot (shared helper, reused by Task 5): `git ls-files -co --exclude-standard -z | tar --null -T - -cz` piped over SSH into `~/.dotfiles`, then inside the VM: `git init -q`, `git add -A`, commit as `vm-test <vm@test>`, `git remote add origin https://github.com/csessh/.dotfiles.git`. (The worktree's `.git` is a pointer file and must not be copied; bootstrap's `git pull --ff-only` then fails harmlessly with a warning, and `remote set-url origin` succeeds.)
- Run `printf '2\n' | ~/.dotfiles/bootstrap.sh` over SSH (Task 2 removes the `printf`), then `~/.dotfiles/tests/check.sh` over a **new** SSH connection.
- `all` = `build ubuntu fedora nixos`, stops at first failure.

- [ ] **Step 4: Run `tests/vm.sh ubuntu` against unmodified bootstrap to find blockers**

Expected: bootstrap stalls or fails at an interactive prompt (Nix installer confirmation on Ubuntu, `chsh` password prompt). Record which.

- [ ] **Step 5: Make bootstrap non-interactive where it must be**

- `install_nix` (non-Fedora branch): `sh -s -- --daemon --yes`.
- `setup_shell`: oh-my-zsh installer with `CHSH=no` (`set_default_shell` owns the shell change).
- `set_default_shell`: `sudo chsh -s "$(command -v zsh)" "$USER"`.

- [ ] **Step 6: Run `tests/vm.sh ubuntu` and `tests/vm.sh fedora`**

Expected on both: bootstrap completes; every check PASSes except `nvim_profile_server`, `no_mason`, `no_dev_plugins` (FAIL — implemented in Task 4).

- [ ] **Step 7: Commit**

```bash
git add tests/ bootstrap.sh
git commit -m "test: VM harness for Ubuntu/Fedora servers; non-interactive bootstrap"
```

---

### Task 2: Trim `bootstrap.sh` to servers; remove Yubikey PAM

**Files:**
- Modify: `bootstrap.sh`, `tests/vm.sh`, `README.md`, `CLAUDE.md`
- Delete: `setup-yubikey-pam.sh`, `Yubikey-auth.md`

**Interfaces:**
- Consumes: Task 1 `tests/vm.sh`, `tests/check.sh`.
- Produces: `bootstrap.sh` with no prompt; `HM_CONFIG` is `linux-server` (x86_64) or `linux-arm-server` (aarch64). `detect_os` still returns `fedora|ubuntu|debian|linux` (Task 6 adds `nixos`).

- [ ] **Step 1: Add the re-run test to `tests/vm.sh`**

For `ubuntu`/`fedora`: before the first bootstrap, write `desktop` to `~/.config/host-type` in the VM; after `check.sh` passes, run `bootstrap.sh` a second time and `check.sh` again. Drop the `printf '2\n' |`.

- [ ] **Step 2: Run `tests/vm.sh ubuntu`**

Expected: FAIL — bootstrap blocks on the host-type prompt (no stdin) or picks the desktop path from the stale file.

- [ ] **Step 3: Remove the desktop path from `bootstrap.sh`**

Delete: the host-type prompt and `~/.config/host-type` write (lines ~57-74), `install_home_manager` (never called), `install_system_packages`, `install_ghostty`, `install_funput_ibus`, `setup_smartcard_services`, `setup_ssh_agent`, every `HOST_TYPE` branch in `main`, and the PAM hint at the end. Server sequence in `main`: `upgrade_system`, `install_essentials`, `clone_dotfiles`, `install_nix`, stow `nix`, stow `home-manager`, home-manager switch, source session vars, `install_server_packages`, `setup_docker_group`, `setup_shell`, `install_tpm`, stow `git nvim tmux bat fastfetch`, `bat cache --build`, `set_default_shell`.

- [ ] **Step 4: Delete `setup-yubikey-pam.sh` and `Yubikey-auth.md`; update docs**

README: remove "Host Type Profiles" and "YubiKey Authentication (Desktop)", fix the Quick Start step list and "What's Managed Where" desktop rows. CLAUDE.md: remove "Change Host Type", the desktop/server profile and native-package-exception lines that no longer apply, and the "Yubikey PAM" paragraph; bootstrap order becomes the server sequence above.

- [ ] **Step 5: Run `tests/vm.sh ubuntu` and `tests/vm.sh fedora`; `shellcheck bootstrap.sh`**

Expected: both runs of bootstrap complete; same PASS/FAIL set as Task 1 Step 6 on both runs; shellcheck reports nothing new versus `main`.

- [ ] **Step 6: Commit**

```bash
git add -A bootstrap.sh tests/vm.sh README.md CLAUDE.md setup-yubikey-pam.sh Yubikey-auth.md
git commit -m "bootstrap: servers only; drop desktop path and Yubikey PAM"
```

---

### Task 3: Flake cleanup for server-only home configs

**Files:**
- Modify: `home-manager/.config/home-manager/flake.nix`, `home-manager/.config/home-manager/packages.nix`

**Interfaces:**
- Produces: `homeConfigurations` with exactly `${USER}` (current system, `desktopEnabled = false`), `linux-server`, `linux-arm-server`. `mkHomeConfig system desktopEnabled` unchanged.
- Produces: `desktopPackages` without `_1password-gui` and `pam_u2f` (still: claude-code, obel-mono, xclip, pcsclite, yubikey-manager).

- [ ] **Step 1: Write the failing check**

```bash
nix eval --impure --json home-manager/.config/home-manager#homeConfigurations --apply builtins.attrNames
```
Expected now: includes `linux` and `linux-arm` → wrong.

- [ ] **Step 2: Edit `flake.nix` and `packages.nix`**

Remove the `hostTypeFile`/`hostType`/`isDesktop` bindings and the `linux`/`linux-arm` entries; default entry becomes `mkHomeConfig currentSystem false`. Remove `_1password-gui` and `pam_u2f` (with its comment block) from `desktopPackages`.

- [ ] **Step 3: Verify**

- Step 1 command prints exactly `["csessh","linux-arm-server","linux-server"]` (with `USER=csessh`).
- `nix eval --impure --raw home-manager/.config/home-manager#homeConfigurations.linux-arm-server.activationPackage.drvPath` prints a `/nix/store/...drv` path (Review Focus 3).
- `tests/vm.sh build` passes.

- [ ] **Step 4: Commit**

```bash
git add home-manager/.config/home-manager/flake.nix home-manager/.config/home-manager/packages.nix
git commit -m "flake: drop desktop home configs and host-type"
```

---

### Task 4: LSP-free nvim on servers

**Files:**
- Move: `nvim/.config/nvim/lua/plugins/{lsp,mason,cmp,conform,linters,snippets,outline,eagle,glance,symbol-usage,trouble}.lua` → `nvim/.config/nvim/lua/plugins/dev/`
- Modify: `nvim/.config/nvim/init.lua`, `home-manager/.config/home-manager/home.nix`, `README.md`, `CLAUDE.md`

**Interfaces:**
- Consumes: Task 3 `desktopEnabled` arg in `home.nix`.
- Produces: env var `NVIM_PROFILE=server` on servers only; nvim loads `plugins.dev` unless `vim.env.NVIM_PROFILE == "server"`.

- [ ] **Step 1: Write the failing local check**

From the worktree, with throwaway data dirs:
```bash
export XDG_CONFIG_HOME="$PWD/nvim/.config" XDG_DATA_HOME="$(mktemp -d)" XDG_STATE_HOME="$(mktemp -d)" XDG_CACHE_HOME="$(mktemp -d)"
NVIM_PROFILE=server nvim --headless "+Lazy! sync" +qa
ls "$XDG_DATA_HOME/nvim/lazy"
```
Expected now: `mason.nvim`, `nvim-cmp`, `trouble.nvim` are present → wrong.

- [ ] **Step 2: Move the 11 files with `git mv`; change `init.lua`**

```lua
local is_server = vim.env.NVIM_PROFILE == "server"
require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.dev", enabled = not is_server },
  },
  change_detection = { notify = false },
})
```

- [ ] **Step 3: Set the variable in `home.nix`**

`home.sessionVariables = lib.mkIf (!desktopEnabled) { NVIM_PROFILE = "server"; };` (add `lib` and `desktopEnabled` to the module args).

- [ ] **Step 4: Verify locally**

- Step 1 again (fresh temp dirs): none of the 11 dev plugin dirs listed in Task 1 `no_dev_plugins` exist; no `mason` dir.
- Same with `env -u NVIM_PROFILE`: `mason.nvim`, `nvim-cmp`, `trouble.nvim` present and exit code 0 (Review Focus 2).

- [ ] **Step 5: Add the re-switch check to `tests/vm.sh ubuntu`**

After `check.sh`, run `home-manager switch --impure` in the VM (no `#config`), then `check.sh` again (Review Focus 4).

- [ ] **Step 6: Run `tests/vm.sh ubuntu` and `tests/vm.sh fedora`**

Expected: every check PASSes on both, including after the second bootstrap and the re-switch.

- [ ] **Step 7: Docs**

README: note for existing servers — after pulling, run `:Lazy clean` once and `rm -rf ~/.local/share/nvim/mason`. CLAUDE.md "Neovim": LSP/format/lint plugins live in `lua/plugins/dev/` and are skipped when `NVIM_PROFILE=server`.

- [ ] **Step 8: Commit**

```bash
git add -A nvim/.config/nvim home-manager/.config/home-manager/home.nix tests/vm.sh README.md CLAUDE.md
git commit -m "nvim: skip LSP plugins on servers via NVIM_PROFILE"
```

---

### Task 5: NixOS system config for `fw13`

**Files:**
- Create: `home-manager/.config/home-manager/nixos/configuration.nix`, `home-manager/.config/home-manager/nixos/hardware-configuration.nix`
- Modify: `home-manager/.config/home-manager/flake.nix`, `home-manager/.config/home-manager/flake.lock`, `tests/vm.sh`
- Delete: `ssh/.config/systemd/user/ssh-agent.service`

**Interfaces:**
- Consumes: Task 3 `home.nix` args `{ username, homeDir, desktopEnabled }`.
- Produces: `nixosConfigurations.fw13` with `config.system.build.toplevel` and `config.system.build.vm`. VM reads `/tmp/shared/authorized_keys` and the repo tarball `/tmp/shared/dotfiles.tar.gz` from `SHARED_DIR`.

- [ ] **Step 1: Write the failing check**

Add to `tests/vm.sh build`: `nix build --no-link home-manager/.config/home-manager#nixosConfigurations.fw13.config.system.build.toplevel` (pure, no `--impure`). Run it. Expected: FAIL, attribute missing.

- [ ] **Step 2: Flake**

Input `nixos-hardware.url = "github:NixOS/nixos-hardware";` then `nix flake lock`. `nixosConfigurations.fw13 = nixpkgs.lib.nixosSystem` (no `system` argument — `nixpkgs.hostPlatform` in the hardware config sets it, as the real generated file will) with modules: `./nixos/configuration.nix`, `nixos-hardware.nixosModules.framework-13-7040-amd`, `home-manager.nixosModules.home-manager`, and an inline module setting `home-manager.useGlobalPkgs = true`, `home-manager.useUserPackages = true`, `home-manager.extraSpecialArgs = { username = "csessh"; homeDir = "/home/csessh"; desktopEnabled = true; }`, `home-manager.users.csessh = { pkgs, ... }: { imports = [ ./home.nix ]; home.file.".local/lib/opensc-pkcs11.so".source = "${pkgs.opensc}/lib/opensc-pkcs11.so"; }`.

- [ ] **Step 3: `nixos/hardware-configuration.nix` placeholder**

Header comment: replaced by `nixos-generate-config` output at install. Content: `fileSystems."/" = { device = "/dev/disk/by-label/nixos"; fsType = "btrfs"; }; fileSystems."/boot" = { device = "/dev/disk/by-label/boot"; fsType = "vfat"; };`, `nixpkgs.hostPlatform = "x86_64-linux";`.

- [ ] **Step 4: `nixos/configuration.nix`**

Every row of the spec's "NixOS system config" table and its "Plus" list, with these exact values:
- `imports = [ ./hardware-configuration.nix ];`
- `boot.loader.systemd-boot.enable = true; boot.loader.efi.canTouchEfiVariables = true;`
- `networking.hostName = "fw13"; networking.networkmanager.enable = true;`
- `time.timeZone = "Asia/Ho_Chi_Minh"; i18n.defaultLocale = "en_AU.UTF-8"; i18n.extraLocales = [ "en_US.UTF-8/UTF-8" ]; console.keyMap = "us"; services.xserver.xkb.layout = "au";`
- `services.desktopManager.gnome.enable = true; services.displayManager.gdm.enable = true; hardware.graphics.enable = true;`
- `services.fprintd.enable = true;` (no PAM overrides — NixOS default `sufficient`)
- `services.pcscd.enable = true; programs.ssh.startAgent = true; programs.ssh.agentPKCS11Whitelist = "/nix/store/*"; services.gnome.gcr-ssh-agent.enable = false;`
- `programs._1password-gui = { enable = true; polkitPolicyOwners = [ "csessh" ]; }; programs._1password.enable = true;`
- `i18n.inputMethod = { enable = true; type = "ibus"; ibus.engines = with pkgs.ibus-engines; [ bamboo ]; };`
- `virtualisation.docker.enable = true; programs.nix-ld.enable = true; programs.zsh.enable = true; zramSwap.enable = true;`
- `users.users.csessh = { isNormalUser = true; extraGroups = [ "wheel" "docker" "networkmanager" ]; shell = pkgs.zsh; };`
- `environment.systemPackages = with pkgs; [ git stow curl unzip make opensc ghostty obsidian google-chrome postman dbeaver-bin localsend yubioath-flutter ];`
- `environment.sessionVariables.NIXOS_OZONE_WL = "1"; nixpkgs.config.allowUnfree = true; nix.settings.experimental-features = [ "nix-command" "flakes" ]; system.stateVersion = "26.11";`
- `virtualisation.vmVariant = { virtualisation.diskSize = 16384; virtualisation.memorySize = 4096; virtualisation.cores = 4; services.openssh.enable = true; services.openssh.authorizedKeysFiles = [ "/tmp/shared/authorized_keys" ]; services.openssh.settings.StrictModes = false; security.sudo.wheelNeedsPassword = false; };` (`StrictModes = false` because sshd rejects key files under world-writable `/tmp`; VM only)

- [ ] **Step 5: Delete the stowed ssh-agent unit**

`git rm ssh/.config/systemd/user/ssh-agent.service` (NixOS `programs.ssh.startAgent` replaces it; `ssh` is stowed only on the workstation).

- [ ] **Step 6: `tests/vm.sh nixos` boots**

`nix build` `...#nixosConfigurations.fw13.config.system.build.vm`; put `authorized_keys` and the repo tarball (Task 1 snapshot helper, as a file) in a fresh `SHARED_DIR` under the cache dir; run `result/bin/run-fw13-vm` with `NIX_DISK_IMAGE=<cache>/nixos.qcow2` (deleted before each run), `QEMU_NET_OPTS="hostfwd=tcp::2223-:22"`, `QEMU_OPTS="-display none -serial file:<cache>/logs/nixos.log"`; `wait_for_ssh` on 2223. For now, end the stage with `ssh ... systemctl is-system-running --wait` and accept `running` or `degraded` (log failed units), then exit 0.

- [ ] **Step 7: Verify**

`git add -A` then `tests/vm.sh build` passes (both builds) and `tests/vm.sh nixos` reaches SSH.

- [ ] **Step 8: Commit**

```bash
git add -A home-manager/.config/home-manager ssh tests/vm.sh
git commit -m "nixos: fw13 system config with home-manager module"
```

---

### Task 6: Bootstrap on NixOS, NixOS checks, runbook

**Files:**
- Modify: `bootstrap.sh`, `tests/check.sh`, `tests/vm.sh`, `README.md`, `CLAUDE.md`

**Interfaces:**
- Consumes: Task 5 VM stage, Task 1 `check.sh` structure.
- Produces: `detect_os` returns `nixos` when `/etc/os-release` `ID=nixos`; `main` dispatches to a NixOS-only sequence.

- [ ] **Step 1: Write the NixOS checks in `tests/check.sh`**

`nixos)` branch:
- `hm_activation`: `systemctl show -p Result home-manager-csessh.service` is `Result=success`.
- `mason_binaries`: `nvim --headless -c "MasonInstall bash-language-server clangd docker-compose-language-service dockerfile-language-server lua-language-server markdown-oxide pyright ruff taplo typescript-language-server cpplint eslint_d jsonlint shellcheck yamllint" -c qa` exits 0; then every file in `~/.local/share/nvim/mason/bin/` run with `--version </dev/null` under `timeout 10` must not exit 126/127 and its output must not contain `Could not start dynamically linked executable` or `No such file or directory` (the nix-ld proof; other non-zero exits are fine).
- `pcscd_active`: `systemctl is-active pcscd.socket` or `pcscd.service` is `active`.
- `ssh_agent`: `systemctl --user is-active ssh-agent` is `active` and `$SSH_AUTH_SOCK` in `zsh -i` is non-empty.
- `stow_links_desktop`: same test for `~/.config/ghostty/config ~/.ssh/config`.
- `apps_on_path`: `ghostty obsidian google-chrome-stable postman dbeaver localsend_app yubioath-flutter` all resolve with `command -v` (each package's `meta.mainProgram`, verified).
- `ghostty_version`: `ghostty --version` exits 0.
- `ibus_bamboo`: `/run/current-system/sw/share/ibus/component/bamboo.xml` exists.
- `fingerprint_pam`: `systemctl cat fprintd.service` succeeds; `/etc/pam.d/sudo` contains `pam_fprintd.so`; `grep -r pam_u2f /etc/pam.d` finds nothing.

- [ ] **Step 2: Extend `tests/vm.sh nixos`**

After SSH is up: unpack `/tmp/shared/dotfiles.tar.gz` into `~/.dotfiles` with the same git-init steps as Task 1, run `~/.dotfiles/bootstrap.sh`, `check.sh` over a new SSH connection, then `bootstrap.sh` + `check.sh` a second time (Review Focus 5).

- [ ] **Step 3: Run `tests/vm.sh nixos`**

Expected: FAIL — bootstrap takes the generic `linux` path (tries apt/dnf/Nix install).

- [ ] **Step 4: NixOS path in `bootstrap.sh`**

`detect_os`: `ID=nixos` → `nixos`. In `main`, before the server sequence: if `nixos`, run `clone_dotfiles`, `setup_shell`, `install_tpm`, stow `git nvim tmux bat fastfetch ghostty ssh`, `bat cache --build`, print done, return.

- [ ] **Step 5: Run `tests/vm.sh nixos`**

Expected: every check PASSes on both bootstrap runs. If a check fails because the spec's config is wrong (not the check), fix `configuration.nix` and note it in the commit message.

- [ ] **Step 6: Docs**

README: new "NixOS workstation" section with the spec's runbook (back up `/home`; install with hand partitioning; commit generated `hardware-configuration.nix`; `nixos-install --flake ~/.dotfiles/home-manager/.config/home-manager#fw13`; first boot: clone, `bootstrap.sh`, `fprintd-enroll`, `sudo -k && sudo true`; update `nix flake update ~/.dotfiles/home-manager/.config/home-manager && sudo nixos-rebuild switch --flake ~/.dotfiles/home-manager/.config/home-manager#fw13`, regularly — Chrome is pinned; rollback `sudo nixos-rebuild switch --rollback` or boot menu) and "Running the VM tests" (`tests/vm.sh all`, cache location, ~20 GB disk). CLAUDE.md: Architecture gains the NixOS layer (`nixos/`, home-manager as module, `bootstrap.sh` NixOS branch), Common Commands gains rebuild/update/rollback and `tests/vm.sh`.

- [ ] **Step 7: Full run**

`tests/vm.sh all`. Expected: exit 0.

- [ ] **Step 8: Commit**

```bash
git add bootstrap.sh tests/ README.md CLAUDE.md home-manager/.config/home-manager/nixos
git commit -m "bootstrap: NixOS user-level path; NixOS VM checks and runbook"
```
