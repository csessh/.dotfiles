# Dotfiles

Personal development configuration files managed with GNU Stow and Nix + home-manager.

Supports Fedora, Ubuntu, and macOS.

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

1. Install Nix (Fedora: native package, others: official installer)
2. Enable flakes via stow
3. Install home-manager
4. Apply home-manager configuration (installs all Nix packages)
5. Install system packages (Docker, PAM, Firefox)
6. Add user to docker group
7. Install oh-my-zsh, remove stock .zshrc, stow shell config
8. Install TPM (Tmux Plugin Manager)
9. Stow all remaining configuration packages
10. Set zsh as default shell

After bootstrap, log out and back in for all changes to take effect.

## Manual Setup

If you prefer to run steps manually:

```bash
# 1. Install Nix (Fedora)
sudo dnf install nix
sudo systemctl enable --now nix-daemon

# 2. Clone dotfiles
git clone https://github.com/csessh/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 3. Enable flakes
stow nix

# 4. Install home-manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# 5. Stow home-manager config and apply
stow home-manager
git add home-manager  # Required for flakes
home-manager switch --impure  # --impure to read $USER/$HOME

# 6. Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm ~/.zshrc  # Remove stock zshrc

# 7. Stow configs
stow shell git nvim tmux bat pet fastfetch ghostty ssh Yubico

# 8. Set default shell
chsh -s $(which zsh)
```

## Package Management

### Adding a new package

Edit `~/.dotfiles/home-manager/.config/home-manager/packages.nix`:

```nix
home.packages = with pkgs; [
  # Add your package here
  newpackage
];
```

Then apply:

```bash
git add home-manager  # If file changed
home-manager switch --impure
```

### Updating packages

```bash
# Update flake inputs (gets latest nixpkgs)
nix flake update ~/.config/home-manager

# Apply updates
home-manager switch
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

- [bat](./bat/README.md) - cat replacement with syntax highlighting
- [fastfetch](./fastfetch/README.md) - system information tool
- [ghostty](./ghostty/README.md) - terminal emulator
- [git](./git/README.md) - git and lazygit configuration
- [nvim](./nvim/README.md) - neovim configuration
- [pet](./pet/README.md) - command snippet manager
- [shell](./shell/README.md) - zsh configuration (requires oh-my-zsh)
- [ssh](./ssh/README.md) - SSH configuration
- [tmux](./tmux/README.md) - tmux configuration
- [Yubico](./Yubico/README.md) - YubiKey configuration

## What's Managed Where

| Component | Manager | Notes |
|-----------|---------|-------|
| CLI tools (ripgrep, fd, fzf, bat, etc.) | Nix | Declarative, reproducible |
| Dev tools (neovim, tmux, git) | Nix | Same versions across machines |
| Languages (nodejs, python, go) | Nix | Consistent toolchain |
| Docker | System (dnf/apt/brew) | System integration |
| Firefox | System (dnf/apt/brew) | Better desktop integration |
| PAM/YubiKey | System (dnf/apt) | System-level authentication |
| oh-my-zsh | curl installer | Shell framework |
| Configs | Stow | Symlinked from dotfiles |
