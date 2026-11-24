# NixOS Workstation Design

Date: 2026-11-24
Status: Approved

## Intent

Migrate the personal workstation (Framework 13 AMD, hostname `fw13`, currently Fedora 43 + GNOME Wayland) to NixOS so the **whole machine** — system and user level — is declared in code and tracked in this repo, the same way the dotfiles are today.

The same repo must keep deploying to the Fedora and Ubuntu remote servers exactly as it does now (standalone home-manager + Stow + `bootstrap.sh`).

NixOS becomes the only desktop target: the Fedora/Ubuntu **desktop** path in `bootstrap.sh` is removed, so non-NixOS hosts are servers only.

Deliverable of this project: the NixOS config in the repo, a slimmed `bootstrap.sh` (servers + NixOS user-level steps), plus a VM test harness that proves it works on NixOS **and** that nothing regressed on Ubuntu and Fedora. Installing NixOS on the real laptop is a follow-up done by hand from a short runbook in the README.

## Goals

- `nixosConfigurations.fw13` that reproduces today's workstation: GNOME Wayland, Docker, Yubikey for SSH (PIV ssh-agent), fingerprint for login/lock screen/sudo, 1Password, Vietnamese input, the kept GUI apps.
- Home-manager runs as a NixOS module on the workstation: one `nixos-rebuild switch` applies system + user.
- Stow configs unchanged in behaviour; they deploy on NixOS with the same `stow <pkg>` commands.
- Neovim LSPs stay with Mason on the workstation. Servers run the same nvim config without the LSP/completion/format/lint plugins (development happens on the workstation; servers are for quick edits).
- One test entry point that boots NixOS, Ubuntu and Fedora VMs and runs one shared check script on each.
- One `bootstrap.sh` for every host: full install on Fedora/Ubuntu servers, user-level steps only on NixOS. No duplicated step lists between script and README.
- Remove everything only the non-NixOS desktop used.

## Non-goals

- Go tooling (no `gopls`, nothing Go-specific).
- Moving LSPs/linters out of Mason into Nix.
- Replacing Stow with home-manager file management.
- Declaring system state on Fedora/Ubuntu (no system-manager); `bootstrap.sh` keeps that job there.
- Declarative disk partitioning (no disko).
- Disk encryption (no LUKS), same as today.
- Yubikey PAM (U2F) anywhere. `setup-yubikey-pam.sh` and `Yubikey-auth.md` are deleted.
- Bootstrapping a Fedora/Ubuntu desktop. That path is deleted, not kept untested.
- Desktops other than GNOME. KDE Plasma, COSMIC and tiling WMs (Hyprland/niri/Sway) were considered; trying one later fits as a NixOS `specialisation`, not part of this project.
- Performing the real laptop install.

## Anti-goals (failure even if NixOS works)

- Any change to a shared file that breaks `bootstrap.sh` or `home-manager switch --impure` on a Fedora/Ubuntu server.
- NixOS-only paths or options leaking into shared files without a fallback that works on other distros.
- Secrets or per-device material (fingerprint enrollments, SSH keys) committed to git.

## Constraints

- All work happens on branch `exp/nixos`, in a **git worktree** (not in `~/.dotfiles` itself). `~/.dotfiles` is live: its Stow packages are symlinked into `$HOME` on the current Fedora laptop, so editing or deleting files there changes the running system (e.g. deleting the ssh-agent unit would break SSH today). The Fedora laptop stays on `main` until the migration.
- Shared files: `home-manager/.config/home-manager/{flake.nix,home.nix,packages.nix}`, every Stow package, `bootstrap.sh`.
- The flake stays at `home-manager/.config/home-manager/flake.nix`: servers rely on `~/.config/home-manager` (a Stow symlink) being the default flake path.
- Server-side `homeConfigurations` keep reading `$USER` and `$HOME` with `--impure`.
- Host has `/dev/kvm`, qemu, libvirt and Nix 2.31; tests run locally, not in CI.
- `nixpkgs` follows `nixos-unstable` (as today). Chrome, like everything else, only updates on `nix flake update` — accepted chore, do it regularly.

## Approaches

### Testing (chosen: B)

- **A. `runNixOSTest` + separate qemu harness for Ubuntu/Fedora.** Hermetic and reproducible, but the Nix build sandbox has no network, so Mason downloads, oh-my-zsh and TPM clones cannot be exercised on NixOS — the single biggest risk goes untested. Two harnesses to maintain.
- **B. Real VMs for every OS, one script, one shared check script.** NixOS via `nixos-rebuild build-vm`, Ubuntu/Fedora via cloud images + cloud-init under qemu. Exercises the network-dependent parts. Slower (minutes per OS), less hermetic. **Chosen** because it tests what actually runs on each machine, and identical checks make "works on X" comparable.
- **C. Containers for Ubuntu/Fedora.** Rejected: `bootstrap.sh` needs systemd (nix-daemon, docker, pcscd); containers would force patching around the script and test something the servers never run.

### LSPs on NixOS (chosen: Mason + nix-ld)

- Mason + `programs.nix-ld.enable`: Mason's prebuilt binaries (clangd, lua-language-server, markdown-oxide, taplo, shellcheck, ruff wheel) need the FHS dynamic loader; nix-ld provides it. **Chosen** — user wants Mason to stay with nvim on every host.
- LSPs in `packages.nix`: pinned and pure, but rejected by the user.

### Trimmed nvim on servers (chosen: A)

- **A. One config, LSP-family plugins in `lua/plugins/dev/`, skipped on servers.** Server signal comes from home-manager. **Chosen**: one config to maintain, ~3 lines in `init.lua` plus a folder move.
- **B. Second config (`nvim-lite` Stow package).** Rejected: two copies of options/keymaps/theme drift apart.
- **C. No nvim config on servers.** Rejected: loses keymaps, theme, telescope, tmux navigation.

### GUI apps (chosen: nixpkgs, no Flatpak)

Kept: Obsidian, Google Chrome, Postman, DBeaver, LocalSend, Yubico Authenticator, Ghostty, 1Password. All from nixpkgs (verified present for x86_64-linux in the pinned lock). Every other current Flatpak/rpm app (Slack, Discord, Zoom, OBS, Chromium, pdfarranger, KCC, Extension Manager) is dropped; ad hoc use via `nix shell nixpkgs#<app>` or by adding it to config. With no Flatpaks left, `services.flatpak` / nix-flatpak are not used.

### Input method

Funput is not in nixpkgs. Replaced on NixOS by `ibus-engines.bamboo`. `install_funput_ibus` is deleted with the rest of the non-NixOS desktop path.

## Decided design

### Repo layout

```
home-manager/.config/home-manager/
  flake.nix            # + nixosConfigurations.fw13, + nixos-hardware input
  home.nix             # unchanged
  packages.nix         # drops _1password-gui, pam_u2f from desktopPackages
  nixos/
    configuration.nix  # system config for fw13
    hardware-configuration.nix  # generated at install; placeholder until then
tests/
  vm.sh                # entry point: tests/vm.sh {nixos|ubuntu|fedora|all}
  check.sh             # shared checks, run inside each VM over SSH
  cloud-init/          # user-data template for Ubuntu/Fedora
docs/superpowers/specs/2026-11-24-nixos-workstation-design.md

deleted: setup-yubikey-pam.sh, Yubikey-auth.md,
         ssh/.config/systemd/user/ssh-agent.service
```

`nixos/` lives inside the flake directory so the flake references it with plain relative paths. On servers it rides along inside the Stow symlink and is never evaluated.

### Flake

- New input `nixos-hardware` for `framework-13-7040-amd` (AMD Phoenix GPU, power, fwupd).
- `nixosConfigurations.fw13`: `nixpkgs.lib.nixosSystem` with `./nixos/configuration.nix`, the nixos-hardware module, and `home-manager.nixosModules.home-manager` importing the existing `./home.nix` with `extraSpecialArgs = { username = "tdo"; homeDir = "/home/tdo"; desktopEnabled = true; }`. `desktopEnabled = true` now only happens here.
- `homeConfigurations`: keep `linux-server`, `linux-arm-server` and the default `${username}` config, which becomes server-only (`desktopEnabled = false`). Delete the desktop `linux` / `linux-arm` configs and the `~/.config/host-type` read. A leftover `host-type` file on existing servers is ignored.
- `nixosConfigurations` must evaluate without `--impure` (no `getEnv`); the `let` block's impure reads stay confined to `homeConfigurations`.

### NixOS system config (`configuration.nix`)

Mapping from `bootstrap.sh` steps:

| bootstrap.sh | NixOS |
|---|---|
| `install_essentials` (git stow curl zsh unzip make) | `environment.systemPackages`; `programs.zsh.enable` |
| `install_nix`, nix.conf flakes | built in; `nix.settings.experimental-features` |
| `install_system_packages` (opensc, docker) | `environment.systemPackages = [ opensc ]`; `virtualisation.docker.enable` |
| `install_ghostty` | `ghostty` from nixpkgs (GPU drivers via `hardware.graphics.enable`) |
| `install_funput_ibus` | `i18n.inputMethod = { enable = true; type = "ibus"; ibus.engines = [ bamboo ]; }` |
| `setup_smartcard_services` (pcscd) | `services.pcscd.enable` |
| `setup_smartcard_services` (opensc symlink) | home-manager `home.file.".local/lib/opensc-pkcs11.so".source = "${pkgs.opensc}/lib/opensc-pkcs11.so"`, NixOS only |
| `setup_ssh_agent` + stowed `ssh-agent.service` | `programs.ssh.startAgent = true`; `programs.ssh.agentPKCS11Whitelist = "/nix/store/*"`; `services.gnome.gcr-ssh-agent.enable = false` |
| `setup_docker_group` | `users.users.tdo.extraGroups = [ "wheel" "docker" ]` |
| `set_default_shell` | `users.users.tdo.shell = pkgs.zsh` |
| `setup-yubikey-pam.sh` (sudo, gdm-password) | replaced by fingerprint: `services.fprintd.enable = true` |

Plus:
- Boot: systemd-boot, UEFI. Filesystem: btrfs root/home like today (exact subvolumes from the generated hardware config).
- `zramSwap.enable = true` (matches today's zram swap).
- Desktop: `services.desktopManager.gnome.enable`, `services.displayManager.gdm.enable` (Wayland default).
- `hardware.graphics.enable`.
- `programs.nix-ld.enable` (Mason).
- `programs._1password-gui = { enable = true; polkitPolicyOwners = [ "tdo" ]; }` and `programs._1password.enable` (CLI).
- `environment.sessionVariables.NIXOS_OZONE_WL = "1"` (native Wayland for Electron apps).
- `environment.systemPackages` / user packages: obsidian, google-chrome, postman, dbeaver-bin, localsend, yubioath-flutter, ghostty.
- `nixpkgs.config.allowUnfree = true`.
- Hostname `fw13`, user `tdo`, timezone and locale copied from the current Fedora install.

Authentication on NixOS: fingerprint (Goodix `27c6:609c`, libfprint 1.94.100 in the pinned nixpkgs, same version as Fedora today) replaces Yubikey U2F. `services.fprintd.enable = true` is set explicitly even though the nixos-hardware Framework module defaults it on. NixOS then adds `pam_fprintd` as `sufficient` to PAM services by default (`fprintAuth`), so sudo accepts fingerprint **or** password; GDM offers fingerprint through its own `gdm-fingerprint` stack. Known behaviour, accepted: logging in to GDM by fingerprint does not unlock GNOME Keyring, so the first keyring use in that session (e.g. Chrome) prompts for the password. Logging in by password avoids it.

The Yubikey stays for SSH only: pcscd, opensc, ssh-agent PIV, Yubico Authenticator, yubikey-manager. Fingerprints are enrolled after install with `fprintd-enroll` (runbook step); enrollments are not in git.

### Shared-file changes

- **nvim server profile:**
  - Move these plugin specs from `nvim/.config/nvim/lua/plugins/` to `lua/plugins/dev/`: `lsp`, `mason`, `cmp`, `conform`, `linters`, `snippets`, `outline`, `eagle`, `glance`, `symbol-usage`, `trouble`. No kept file requires any of them (checked); `lua/snippets/*` is only loaded by `snippets.lua`.
  - `init.lua`: `local is_server = vim.env.NVIM_PROFILE == "server"`; `require("lazy").setup({ spec = { { import = "plugins" }, { import = "plugins.dev", enabled = not is_server } }, change_detection = { notify = false } })`. Verified in lazy.nvim's `Spec:import`: a disabled import is skipped before any spec is read, so those plugins are never installed. `import = "plugins"` does not recurse into `dev/` (same reason `archived/` is ignored today).
  - Signal: home-manager sets `home.sessionVariables.NVIM_PROFILE = "server"` when `desktopEnabled` is false. `.zshrc:9-10` already sources `hm-session-vars.sh`. The workstation never sets it; an unset variable means the full config, so a missing signal degrades to today's behaviour.
  - Existing servers: one-time `:Lazy clean` and `rm -rf ~/.local/share/nvim/mason` (README note). Frees ~539 MB of Mason plus the dev plugins.
- `packages.nix`: remove `_1password-gui` (the NixOS module installs it with the setgid browser helper) and `pam_u2f` from `desktopPackages`. `desktopPackages` is now NixOS-only.
- `ssh/.config/systemd/user/ssh-agent.service`: deleted. The `ssh` Stow package is only deployed on the workstation, which now gets its agent from `programs.ssh.startAgent`. `ssh/.ssh/config` stays.
- `shell/.zshrc`: no change; its first candidate `~/.local/lib/opensc-pkcs11.so` is provided by home-manager on NixOS, and the loop is a no-op on servers without a key.
- `bootstrap.sh`:
  - Remove the host-type prompt and the desktop path: desktop branch of package install, `install_system_packages` desktop variant, `install_ghostty`, `install_funput_ibus`, `setup_smartcard_services`, `setup_ssh_agent`, and the PAM hint at the end.
  - `detect_os` recognises `nixos`. On NixOS it runs only the user-level steps: `clone_dotfiles`, `setup_shell` (oh-my-zsh + stow shell), `install_tpm`, stow `git nvim tmux bat fastfetch ghostty ssh`, `bat cache --build`. It skips upgrade, essentials, Nix install, stow `nix`/`home-manager`, home-manager switch, system packages, docker group and `chsh` (all declared in NixOS).
  - Fedora/Ubuntu: unchanged server behaviour, minus the prompt. Stow list stays `git nvim tmux bat fastfetch`.
- `README.md`, `CLAUDE.md`: drop host-type profiles, desktop native-package exceptions, Yubikey PAM; add the NixOS section (install runbook, rebuild/update/rollback commands).

### Test harness

`tests/vm.sh <os>`:

0. Fast gate for every run: `nix build` of `nixosConfigurations.fw13.config.system.build.toplevel` and `homeConfigurations.linux-server.activationPackage` (impure). Fails in seconds on eval errors.
1. **nixos**: build `nixosConfigurations.fw13.config.system.build.vm`. A `virtualisation.vmVariant` block (VM builds only) sets disk ≥ 16 GB, memory ≥ 4 GB, enables openssh with the host user's public key, sets `security.sudo.wheelNeedsPassword = false` (unattended sudo for the test run), and forwards a host port to guest 22. Boot headless, wait for SSH, copy the working tree (including `.git`) to `~/.dotfiles`, run `~/.dotfiles/bootstrap.sh` (NixOS branch), then `check.sh`.
2. **ubuntu** (24.04 LTS cloud image) / **fedora** (43 cloud image): download once into a cache dir outside the repo (gitignored), create a qcow2 overlay resized to ≥ 20 GB, cloud-init seed with user `tdo`, passwordless sudo, host public key. Boot headless, wait for SSH, copy the working tree (including `.git`) to `~/.dotfiles`, run `~/.dotfiles/bootstrap.sh`, then `check.sh`. If `chsh` (in `set_default_shell` or the oh-my-zsh installer) blocks on a password prompt, fix it in `bootstrap.sh` in a way that still works on real servers (e.g. `sudo chsh -s "$(which zsh)" "$USER"`).
3. Tear down the VM; keep logs under the cache dir on failure.

`tests/check.sh` (same script on all OSes, run in a fresh login shell):
- `zsh -i -c exit` exits 0 with no stderr.
- Stow symlinks exist for the packages that OS deploys.
- `nvim --headless` starts without errors.
- Workstation (NixOS): Mason `ensure_installed` completes and every binary in `~/.local/share/nvim/mason/bin` runs `--version` (the nix-ld proof).
- Servers (Ubuntu/Fedora): `NVIM_PROFILE=server` in the login environment, `~/.local/share/nvim/mason` does not exist after startup, and none of the `dev/` plugins are under `~/.local/share/nvim/lazy`.
- `docker info` succeeds as the user.
- Home-manager activation succeeded: `home-manager generations` non-empty on Ubuntu/Fedora; `systemctl is-active home-manager-$USER` (oneshot, check result) on NixOS.
- NixOS only: `systemctl is-active pcscd`, `ssh-agent` user service active and `SSH_AUTH_SOCK` points at it, `ghostty --version`, `obsidian`/`google-chrome-stable` present on PATH, ibus bamboo engine listed, `fprintd.service` unit present and enabled, `/etc/pam.d/sudo` contains `pam_fprintd.so`, no `pam_u2f.so` anywhere in `/etc/pam.d` (no reader in the VM, so this checks config only).

GUI rendering is not tested; checks stop at "binary present and starts".

### Runbook (README section)

1. Back up `/home`.
2. Boot the NixOS installer, partition (EFI + root), mount, `nixos-generate-config`, copy the generated `hardware-configuration.nix` into the repo, commit.
3. `nixos-install --flake .../home-manager/.config/home-manager#fw13`.
4. First boot: clone repo, run `~/.dotfiles/bootstrap.sh`, `fprintd-enroll` (one or more fingers), test with `sudo -k && sudo true`.
5. Ongoing: `nix flake update && sudo nixos-rebuild switch --flake ~/.dotfiles/home-manager/.config/home-manager#fw13`; rollback with `--rollback` or boot menu.

## Left to the builder

- Exact qemu flags, port numbers, SSH wait/retry logic, cache dir location.
- How `check.sh` waits for Mason installs (poll the registry or `MasonInstallAll`-style command).
- Timezone/locale values (read from the current host).
- Order of tasks, as long as the fast gate and server tests pass before NixOS work is called done.

## Calls made by Claude (please check)

- Home-manager as a NixOS module on the workstation (one rebuild command) rather than standalone.
- Flake stays in its current location; `nixos/` nested inside it.
- `nixos-hardware` Framework module added.
- No disko; partitions by hand, generated hardware config committed.
- GUI apps declared in `configuration.nix`; `desktopPackages` keeps the existing CLI/font desktop extras (claude-code, obel-mono, xclip, yubikey-manager, pcsclite).
- Host-type mechanism removed rather than kept for a single remaining value.
- ssh-agent moves to `programs.ssh.startAgent`; the stowed unit is deleted instead of patched.
- Implementation in a git worktree because `~/.dotfiles` is live-stowed.
- Fingerprint PAM uses NixOS defaults (`sufficient`: fingerprint or password), not two-factor.
- Test images: Ubuntu 24.04 LTS, Fedora 43.
