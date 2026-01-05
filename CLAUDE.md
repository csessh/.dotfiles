# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles managed with GNU Stow and Nix home-manager. Supports Fedora, Ubuntu, and macOS.

## Architecture

**Two-layer management:**
1. **Nix home-manager** - Installs packages declaratively (CLI tools, dev tools, languages)
2. **GNU Stow** - Symlinks configuration files from dotfiles to home directory

Each tool directory mirrors the target filesystem structure. Deploy with `stow <package>` from repository root.

**Stow packages**: bat, fastfetch, ghostty, git, home-manager, lazygit, nix, nvim, shell, ssh, tmux, Yubico

**Theme**: Cyberdream across nvim, bat, git-delta, tmux, and terminal emulators.

## Common Commands

### Bootstrap (fresh system)
```bash
git clone https://github.com/csessh/.dotfiles.git ~/.dotfiles && ~/.dotfiles/bootstrap.sh
```

### Nix Package Management
```bash
# Add package: edit home-manager/.config/home-manager/packages.nix
git add home-manager && home-manager switch --impure

# Update all packages
nix flake update ~/.config/home-manager && home-manager switch

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

## Neovim

**LSP Servers** (lsp.lua): bashls, clangd, docker_compose_language_service, dockerls, lua_ls (Love2D), markdown_oxide, pyright, ruff, taplo, ts_ls

**Formatters** (conform.lua): stylua (Lua), ruff_format + ruff_organize_imports (Python), eslint_d (TypeScript). Format-on-save with 500ms timeout.

**Linters** (linters.lua): shellcheck, cpplint, jsonlint, selene, ruff, yamllint

**Key bindings**: `<leader>ca` code actions, `<leader>fm` format, `<leader>rn` rename

## Tmux

Prefix: `C-Space`

- `<prefix>hjkl` select pane, `<prefix>HJKL` swap pane
- `M-hjkl` resize (no prefix)
- `<prefix>s` horizontal split, `<prefix>v` vertical split
- `<prefix>r` reload config
- `<prefix><C-s>` save session, `<prefix><C-r>` restore
- `<prefix>Enter` toggle synchronize-panes
- `<C-h/j/k/l>` seamless nvim-tmux navigation

## Shell (zsh)

Uses zinit for plugins (zsh-syntax-highlighting, zsh-completions, zsh-autosuggestions) and oh-my-zsh framework.

**Aliases**: `cat`→bat, `vim`/`v`→nvim, `lazy`→lazygit, `tmx`→tmux, `stwo`→stow

**Functions** (scripts.zsh): `nah [-f]` git reset, `snipe` kill process via fzf, `activate` source venv, `zeload` reload zshrc, `mkd` mkdir+cd, `paths` list PATH, `dockerps` formatted docker ps, `filesize` sorted file sizes

**Keybindings**: `Ctrl+P/N` history search, `Ctrl+Z` fg

## Development Workflow

1. Edit configs in package directory
2. Test with `stow -R <package>`
3. For Nix packages: edit packages.nix, run `home-manager switch --impure`
