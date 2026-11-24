# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles managed with GNU Stow and Nix home-manager. `bootstrap.sh` sets up Fedora and Ubuntu **servers**.

## Architecture

**Two-layer management:**
1. **Nix home-manager** - Installs packages declaratively (CLI tools, dev tools, languages)
2. **GNU Stow** - Symlinks configuration files from dotfiles to home directory

**Servers** get `basePackages` only (CLI tools, dev tools, languages). `desktopPackages` belong to the workstation.

**Why `--impure` flag**: The server configs read `$USER` and `$HOME` at runtime.

**Native package manager exception**: Docker is installed via dnf/apt for system integration.

**Stow packages**: bat, claude (workstation), fastfetch, ghostty (workstation), git, home-manager, lazygit, nix, nvim, shell, ssh (workstation), tmux

**Bootstrap order**: system upgrade → essentials → dotfiles clone → nix → stow nix config → stow home-manager → home-manager switch → Docker → docker group → oh-my-zsh → TPM → stow remaining configs → bat cache → zsh as login shell. Safe to re-run.

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

### Nix Package Management
```bash
# Add package: edit home-manager/.config/home-manager/packages.nix
# - basePackages: all hosts
# - desktopPackages: workstation only
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

## Neovim

**Server profile**: LSP, completion, format and lint plugins live in `lua/plugins/dev/`. `init.lua` skips that folder when `NVIM_PROFILE=server`, which the server home-manager config sets; the workstation loads everything.

**LSP Servers** (dev/lsp.lua): bashls, clangd, docker_compose_language_service, dockerls, lua_ls (Love2D), markdown_oxide, pyright, ruff, taplo, ts_ls

**Formatters** (dev/conform.lua): stylua (Lua), ruff_format + ruff_organize_imports (Python), eslint_d (.ts files only). Format-on-save with 500ms timeout.

**Linters** (dev/linters.lua): bash→shellcheck, cpp→cpplint, json→jsonlint, python→ruff, yaml→yamllint

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

**Yubikey PIV**: On shell startup, `.zshrc` loads the Yubikey PIV key into ssh-agent via `ssh-add -s`. The opensc library is linked at `~/.local/lib/opensc-pkcs11.so` on the workstation.

**Aliases**: `cat`→bat, `vim`/`v`→nvim, `lazy`→lazygit, `tmx`→tmux, `stwo`→stow

**Functions** (scripts.zsh): `nah [-f]` git reset, `snipe` kill process via fzf, `activate` source venv, `zeload` reload zshrc, `mkd` mkdir+cd, `paths` list PATH, `dockerps` formatted docker ps, `filesize` sorted file sizes, `today` current date, `keychron [-u]` hidraw permissions, `trim` strip whitespace, `rgrep` recursive grep

**Keybindings**: `Ctrl+P/N` history search, `Ctrl+Z` fg

## Development Workflow

1. Edit configs in package directory
2. Test with `stow -R <package>`
3. For Nix packages: edit packages.nix, run `home-manager switch --impure`
