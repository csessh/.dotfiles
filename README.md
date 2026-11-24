# Dotfiles

Personal development configuration files managed with GNU Stow and Nix + home-manager.

`bootstrap.sh` sets up Fedora and Ubuntu **servers**.

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

1. Upgrade system packages and install essentials (git, stow, curl, zsh)
2. Install Nix (Fedora: native package, others: official installer)
3. Enable flakes via stow
4. Install home-manager and apply the server configuration
5. Install system packages (Docker)
6. Add user to docker group
7. Install oh-my-zsh, remove stock .zshrc, stow shell config
8. Install TPM (Tmux Plugin Manager)
9. Stow configuration packages (git, nvim, tmux, bat, fastfetch)
10. Set zsh as default shell

Re-running it on an existing server is safe.

After bootstrap, log out and back in for all changes to take effect.

### Upgrading an existing server

Servers run nvim without LSP/completion/format/lint plugins (`NVIM_PROFILE=server`). After pulling this change and re-running `bootstrap.sh` (or `home-manager switch --impure`), open a new shell and free the old plugins once:

```bash
nvim --headless "+Lazy! clean" +qa
rm -rf ~/.local/share/nvim/mason
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

| Package | Description | Workstation Only |
|---------|-------------|--------------|
| [bat](./bat/README.md) | cat replacement with syntax highlighting | |
| [claude](./claude/README.md) | Claude Code global instructions and statusline | Yes |
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
| Docker | System (dnf/apt) | System integration |
| oh-my-zsh | curl installer | Shell framework |
| Configs | Stow | Symlinked from dotfiles |
