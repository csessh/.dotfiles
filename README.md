# Dotfiles

Personal development configuration files managed with GNU Stow and Nix + home-manager.

Supports Fedora and Ubuntu with **desktop** and **server** profiles.

## Quick Start

**One-liner** (on a fresh system):

```bash
git clone https://github.com/csessh/.dotfiles.git ~/.dotfiles && ~/.dotfiles/bootstrap.sh
```

**Or step by step:**

```bash
# Clone the repo (uses HTTPS for fresh systems without SSH keys)
git clone https://github.com/csessh/.dotfiles.git ~/.dotfiles

# Run bootstrap script
~/.dotfiles/bootstrap.sh
```

The bootstrap script will:

1. Prompt for host type (desktop/server)
2. Install Nix (Fedora: native package, others: official installer)
3. Enable flakes via stow
4. Save host type to `~/.config/host-type`
5. Install home-manager and apply configuration
6. Install system packages (Docker)
7. Add user to docker group
8. Install oh-my-zsh, remove stock .zshrc, stow shell config
9. Install TPM (Tmux Plugin Manager)
10. Stow configuration packages (desktop-only: ghostty, ssh)
11. Set zsh as default shell

After bootstrap, log out and back in for all changes to take effect.

## Host Type Profiles

Bootstrap prompts for host type:

| Profile | Packages | Stow |
|---------|----------|------|
| **Desktop** | Base + firefox, ghostty, 1password, claude-code, fonts, xclip, pam_u2f, yubikey-manager | All packages + ghostty, ssh |
| **Server** | Base only (CLI tools, dev tools, languages) | Core packages only |

To change host type after bootstrap:

```bash
echo "server" > ~/.config/host-type  # or "desktop"
home-manager switch --impure
```

## Package Management

### Adding a new package

Edit `~/.dotfiles/home-manager/.config/home-manager/packages.nix`:

```nix
let
  basePackages = with pkgs; [
    # Packages for all hosts
    newpackage
  ];

  desktopPackages = with pkgs; [
    # Desktop-only packages
    gui-app
  ];
in { ... }
```

Then apply:

```bash
home-manager switch --impure
```

### Updating packages

```bash
# Update flake inputs (gets latest nixpkgs)
nix flake update ~/.config/home-manager

# Apply updates
home-manager switch --impure
```

### Garbage collection

```bash
# Remove old generations
nix-collect-garbage -d
```

### Rollback

```bash
# List previous generations
home-manager generations

# Roll back to previous generation
home-manager switch --rollback
```

## Configuration Management

Configurations are managed with GNU Stow. Each tool has its own directory that mirrors the target filesystem structure.

```bash
cd ~/.dotfiles

# Deploy a config
stow nvim

# Remove a config
stow -D nvim

# Restow (remove then deploy)
stow -R nvim
```

## Stow Packages

| Package | Description | Desktop Only |
|---------|-------------|--------------|
| [bat](./bat/README.md) | cat replacement with syntax highlighting | |
| [fastfetch](./fastfetch/README.md) | system information tool | |
| [ghostty](./ghostty/README.md) | terminal emulator | Yes |
| [git](./git/README.md) | git and lazygit configuration | |
| [nvim](./nvim/README.md) | neovim configuration | |
| [shell](./shell/README.md) | zsh configuration (requires oh-my-zsh) | |
| [ssh](./ssh/README.md) | SSH configuration | Yes |
| [tmux](./tmux/README.md) | tmux configuration | |

## What's Managed Where

| Component | Manager | Notes |
|-----------|---------|-------|
| CLI tools (ripgrep, fd, fzf, bat, etc.) | Nix | Declarative, reproducible |
| Dev tools (neovim, tmux, git) | Nix | Same versions across machines |
| Languages (nodejs, python, go) | Nix | Consistent toolchain |
| Desktop apps (firefox, 1password, ghostty) | Nix | Desktop profile only |
| Docker | System (dnf/apt) | System integration |
| oh-my-zsh | curl installer | Shell framework |
| Configs | Stow | Symlinked from dotfiles |
