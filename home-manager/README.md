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

# Garbage collection
nix-collect-garbage -d

# Workstation
sudo nixos-rebuild switch --flake ~/.dotfiles/home-manager/.config/home-manager#fw13
```

**Note**: The `--impure` flag is required because the server configs read `$USER` and `$HOME` at runtime. `fw13` is pure.

## Profiles

- **Servers** (`linux-server`, `linux-arm-server`, or the `$USER` default): `basePackages` only, and `~/.config/nvim-profile` so nvim skips its dev plugins.
- **Workstation** (`fw13`): `basePackages` + `desktopPackages`; GUI apps and services come from `nixos/configuration.nix`.

`~/.config/host-type` is no longer read. While it says `desktop`, the server configs refuse to switch so an old desktop is not stripped; delete it to proceed.

## Packages

### Base (all hosts)

**CLI tools**: bat, btop, cmatrix, fastfetch, fd, fzf, glow, lazygit, lsoff, pv, ripgrep, tldr, tree, zoxide

**Dev tools**: codegraph, delta, gcc, gh, git, git-lfs, neovim, tmux, tree-sitter

**Languages**: lua5_4, nodejs, python3 (with pynvim), uv

### Workstation only

**AI tools**: claude-code, rtk

**Cloud**: awscli2, ssm-session-manager-plugin

**Fonts**: Obel Mono

**Utilities**: xclip

**Security**: pcsclite, yubikey-manager

## Version Requirements

Assertions enforce minimum versions:
- fzf: 0.67+
- neovim: 0.11+
- lua: 5.4+
