# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository managed with GNU Stow. It contains configuration files for various development tools and applications on a Fedora Linux system.

## Architecture

Each tool has its own directory (e.g., `nvim/`, `tmux/`, `shell/`, `git/`) that mirrors the target filesystem structure. Deploy with `stow <package>` from repository root.

**Stow packages**: bat, fastfetch, ghostty, git, kitty, lazygit, nvim, pet, shell, ssh, tmux, Yubico

## Common Commands

### GNU Stow Package Management
```bash
cd ~/.dotfiles
stow nvim       # Deploy neovim configuration
stow -D nvim    # Remove/unstow
stow -R nvim    # Restow (remove then deploy)
```

### Neovim Development
- `:Mason` - Install/manage LSPs, linters, formatters
- `:LspInfo` - Show LSP client information (alias to `:checkhealth vim.lsp`)

**LSP Servers** (all in nvim/.config/nvim/lua/plugins/lsp.lua:25-83):
- bashls, clangd, docker_compose_language_service, dockerls
- lua_ls (configured for Love2D support), markdown_oxide
- pyright, ruff (Python)
- taplo (TOML), ts_ls (TypeScript/JavaScript)

**Auto-formatters** (conform.lua:7-12):
- Lua: stylua
- Python: isort → ruff_format (sequential)
- TypeScript: eslint_d
- Format-on-save enabled (500ms timeout)

**Linters** (linters.lua:5-12):
- bash: shellcheck
- cpp: cpplint
- json: jsonlint
- lua: selene
- python: ruff
- yaml: yamllint

**Key bindings**:
- `<leader>ca` - LSP code actions
- `<leader>fm` - Format current buffer
- `<leader>rn` - Rename variable
- `<leader>pt` - Run pytest
- `<leader>pta` - Attach pytest to buffer
- `<leader>ptd` - Detach pytest

**External dependencies**: fzf, ripgrep, fd, xclip

### Tmux
- Prefix key: `C-Space` (customized from default `C-b`)
- TPM installation: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
- tmux-resurrect: `<prefix><C-s>` save sessions, `<prefix><C-r>` restore
- Neovim-tmux navigation: `<C-h/j/k/l>` seamlessly navigate between panes
- Pane navigation: `<prefix>hjkl` to select panes
- Pane resizing: `M-hjkl` (Alt+hjkl, no prefix) resize by 5 units
- Pane swapping: `<prefix>HJKL` to swap panes in direction
- Split panes: `<prefix>s` (horizontal), `<prefix>v` (vertical)
- Reload config: `<prefix>r`

### Shell (zsh)
- Install: `sudo dnf install zsh`
- oh-my-zsh: `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
- Skip default `.zshrc` creation during oh-my-zsh install
- Deploy with `stow shell` after installation

## Development Workflow

1. Edit configurations in appropriate package directory
2. Test with `stow <package>` or `stow -R <package>`
3. Verify changes work as expected before committing
