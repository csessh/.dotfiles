# home-manager

Nix flake for the whole setup: standalone home-manager configs for servers, and `nixosConfigurations.fw13` for the NixOS workstation (home-manager runs there as a NixOS module).

## Configuration

```bash
cd ~/.dotfiles
stow home-manager
```

## Usage

```bash
# Servers: apply configuration
home-manager switch --impure

# Update all packages
nix flake update ~/.config/home-manager && home-manager switch --impure

# Rollback
home-manager generations  # list
home-manager switch --rollback

# Garbage collection (servers; fw13 runs nix.gc weekly)
nix-collect-garbage -d

# Workstation
sudo nixos-rebuild switch --flake ~/.dotfiles/home-manager/.config/home-manager#fw13
```

**Note**: The `--impure` flag is required because the server configs read `$USER` and `$HOME` at runtime. `fw13` is pure.

## Profiles

Each host imports the `home/` modules it needs:

- **Servers** (`linux-server`, `linux-arm-server`, or the `$USER` default): `home/common.nix` + `home/server.nix`, which writes `~/.config/nvim-profile` so nvim skips its dev plugins.
- **Workstation** (`fw13`): `home/common.nix` + `home/desktop.nix`; system services and root-level tools come from `nixos/` (`configuration.nix`, `gnome.nix`, `system-integrated-application.nix`, `yubikey.nix`).

Custom packages live in `pkgs/` and are added to `pkgs` through `overlays.nix`, e.g. `nix build .#nixosConfigurations.fw13.pkgs.lsoff`.

`~/.config/host-type` is no longer read. While it says `desktop`, the server configs refuse to switch so an old desktop is not stripped; delete it to proceed.

## Packages

### Base (all hosts, `home/common.nix`)

**CLI tools**: bat, btop, cmatrix, fastfetch, fd, fzf, glow, lazygit, lsoff, openssl, ripgrep, tree, websocat, wget, zoxide

**Dev tools**: codegraph, delta, gcc, gh, git, git-lfs, neovim, tmux, tree-sitter

**Languages**: go, lua5_4, nodejs, python3 (with pynvim), uv

### Workstation only (`home/desktop.nix`)

**AI tools**: claude-code, rtk

**Cloud**: awscli2, ssm-session-manager-plugin

**Fonts**: Obel Mono

**Apps**: dbeaver, discord, ghostty, google-chrome, postman

**Utilities**: cargo, cloud-utils, qemu (for tests/vm.sh), wl-clipboard

**Security**: yubikey-manager, yubioath-flutter

## Version Requirements

Assertions enforce minimum versions:
- fzf: 0.67+
- neovim: 0.11+
- lua: 5.4+
