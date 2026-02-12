# home-manager

Nix home-manager configuration for declarative package management.

## Configuration

```bash
cd ~/.dotfiles
stow home-manager
```

## Usage

```bash
# Apply configuration
home-manager switch --impure

# Update all packages
nix flake update ~/.config/home-manager && home-manager switch --impure

# Rollback
home-manager generations  # list
home-manager switch --rollback

# Garbage collection
nix-collect-garbage -d
```

**Note**: The `--impure` flag is required because the flake reads `$USER`, `$HOME`, and `~/.config/host-type` at runtime.

## Host Types

Host type is stored in `~/.config/host-type`:
- **desktop**: Full install with GUI apps
- **server**: Minimal CLI-only install

```bash
# Change host type
echo "server" > ~/.config/host-type
home-manager switch --impure
```

## Packages

### Base (all hosts)

**CLI tools**: bat, btop, cloudflared, fastfetch, fd, fzf, lazygit, ripgrep, tree, zoxide

**Dev tools**: delta, gcc, git, git-lfs, neovim, ngrok, tmux

**Languages**: go, lua5_4, nodejs, python3, uv

### Desktop only

**AI tools**: claude-code

**Desktop apps**: 1password-gui

**Fonts**: CommitMono (Nerd Font)

**Utilities**: xclip

**Security**: pam_u2f, pcsclite, yubikey-manager

## Version Requirements

Assertions enforce minimum versions:
- fzf: 0.67+
- neovim: 0.11+
- lua: 5.4+
