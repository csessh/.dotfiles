# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles managed with GNU Stow and Nix home-manager. Supports Fedora and Ubuntu with **desktop** and **server** host type profiles.

## Architecture

**Two-layer management:**
1. **Nix home-manager** - Installs packages declaratively (CLI tools, dev tools, languages)
2. **GNU Stow** - Symlinks configuration files from dotfiles to home directory

**Host type profiles** (Linux only):
- **Desktop**: Full install with GUI apps (1password, claude-code, fonts, yubikey tools); ghostty installed via native package manager for OpenGL compatibility
- **Server**: Minimal CLI-only install (base packages only)

Host type is stored in `~/.config/host-type` during bootstrap and read by flake.nix for subsequent `home-manager switch` calls.

**Why `--impure` flag**: The flake reads `$USER`, `$HOME`, and `~/.config/host-type` at runtime to determine configuration.

**Native package manager exceptions**: Some packages are installed via dnf/apt instead of Nix for compatibility:
- **ghostty**: OpenGL compatibility
- **opensc**: ABI compatibility with system openssh (PKCS#11 module)
- **Docker**: System integration

**Stow packages**: bat, fastfetch, ghostty (desktop), git, home-manager, lazygit, nix, nvim, shell, ssh (desktop), tmux

**Bootstrap order**: essentials → dotfiles clone → nix → stow nix config → stow home-manager → home-manager switch → system packages → oh-my-zsh → TPM → stow remaining configs

**Key directories**:
- `home-manager/.config/home-manager/` - Nix flake and package definitions
- `<package>/.config/<app>/` - Standard XDG config structure (stow deploys to ~/.config/)

**Version requirements** (packages.nix assertions): fzf 0.67+, neovim 0.11+, lua 5.4+

**Theme**: Cyberdream across nvim, bat, git-delta, tmux, and terminal emulators.

## Common Commands

### Bootstrap (fresh system)
```bash
git clone https://github.com/csessh/.dotfiles.git ~/.dotfiles && ~/.dotfiles/bootstrap.sh
```
Bootstrap prompts for host type (desktop/server).

### Nix Package Management
```bash
# Add package: edit home-manager/.config/home-manager/packages.nix
# - basePackages: all hosts
# - desktopPackages: desktop only
home-manager switch --impure

# Update all packages
nix flake update ~/.config/home-manager && home-manager switch --impure

# Rollback
home-manager generations  # list
home-manager switch --rollback

# Garbage collection
nix-collect-garbage -d
```

### GNU Stow
```bash
stow nvim       # Deploy
stow -D nvim    # Remove
stow -R nvim    # Restow
```

### Change Host Type
```bash
echo "server" > ~/.config/host-type  # or "desktop"
home-manager switch --impure
```

## Neovim

**LSP Servers** (lsp.lua): bashls, clangd, docker_compose_language_service, dockerls, lua_ls (Love2D), markdown_oxide, pyright, ruff, taplo, ts_ls

**Formatters** (conform.lua): stylua (Lua), ruff_format + ruff_organize_imports (Python), eslint_d (TypeScript). Format-on-save with 500ms timeout.

**Linters** (linters.lua): shellcheck, cpplint, jsonlint, ruff, yamllint

**Key bindings**: `<leader>ca` code actions, `<leader>fm` format, `<leader>rn` rename

## Tmux

Prefix: `C-Space`

- `<prefix>hjkl` select pane, `<prefix>HJKL` swap pane
- `M-hjkl` resize (no prefix)
- `<prefix>s` horizontal split, `<prefix>v` vertical split
- `<prefix>r` reload config
- `<prefix><C-s>` save session, `<prefix><C-r>` restore (tmux-resurrect)
- `<prefix>Enter` toggle synchronize-panes
- `<C-h/j/k/l>` seamless nvim-tmux navigation

## Shell (zsh)

Uses zinit for plugins (zsh-syntax-highlighting, zsh-completions, zsh-autosuggestions) and oh-my-zsh framework. The `cd` command is zoxide (smart directory jumper).

**Yubikey PIV**: On shell startup, `.zshrc` loads the Yubikey PIV key into ssh-agent via `ssh-add -s`. The opensc library (installed via native dnf/apt for ABI compatibility) is symlinked to `~/.local/lib/opensc-pkcs11.so` by bootstrap.sh.

**Yubikey PAM**: For FIDO2 login/sudo authentication, run `~/.dotfiles/setup-yubikey-pam.sh` (guided wizard with backup/rollback). See `Yubikey-auth.md` for manual steps.

**Aliases**: `cat`→bat, `vim`/`v`→nvim, `lazy`→lazygit, `tmx`→tmux, `stwo`→stow

**Functions** (scripts.zsh): `nah [-f]` git reset, `snipe` kill process via fzf, `activate` source venv, `zeload` reload zshrc, `mkd` mkdir+cd, `paths` list PATH, `dockerps` formatted docker ps, `filesize` sorted file sizes, `today` current date, `keychron [-u]` hidraw permissions, `trim` strip whitespace, `rgrep` recursive grep

**Keybindings**: `Ctrl+P/N` history search, `Ctrl+Z` fg

## Development Workflow

1. Edit configs in package directory
2. Test with `stow -R <package>`
3. For Nix packages: edit packages.nix, run `home-manager switch --impure`
