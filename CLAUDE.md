# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository managed with GNU Stow and automated with Ansible. It contains configuration files for various development tools and applications on a Fedora Linux system.

## Architecture

The repository follows a dual-management approach:

### GNU Stow Structure
- Each tool has its own directory (e.g., `nvim/`, `tmux/`, `shell/`, `git/`)
- Configurations mirror the target filesystem structure
- Deploy with `stow <package>` from repository root

### Ansible Automation
- `ansible/localhost.yml`: Local machine setup (includes GUI tools like kitty, 1password, claude)
- `ansible/remote.yml`: Remote server setup (excludes GUI tools)
- `ansible/roles/`: 13 role-based configurations
- Role execution order matters: `ssh`, `utils`, `git` must run first
- Vault file for secrets management (gitignored)

## Common Commands

### Ansible Deployment
```bash
cd ~/.dotfiles/ansible

# With vault file:
ansible-playbook localhost.yml --become-pass-file vault --vault-pass-file vault

# Without vault file:
ansible-playbook localhost.yml --ask-become-pass --ask-vault-pass

# Remote deployment:
ansible-playbook remote.yml -i "<address>," --become-pass-file vault --vault-pass-file vault

# Validation:
ansible-playbook localhost.yml --syntax-check           # Check syntax
ansible-playbook localhost.yml --check --diff          # Dry-run
```

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
- TPM installation: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
- tmux-resurrect: `<prefix><C-s>` save sessions, `<prefix><C-r>` restore
- Neovim-tmux navigation: `<C-h/j/k/l>` seamlessly navigate between panes
- Configuration file: `.tmux.conf` in tmux directory

### Shell (zsh)
- Install: `sudo dnf install zsh`
- oh-my-zsh: `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
- Skip default `.zshrc` creation during oh-my-zsh install
- Deploy with `stow shell` after installation

## Ansible Role Structure

Roles are executed in specific order (localhost.yml:6-24):
1. **Foundation** (must run first): ssh, utils, git
2. **Configured tools**: docker, 1password, bat, claude, fastfetch, kitty, pet
3. **Essentials**: tmux, neovim, shell

Remote playbook (remote.yml) excludes GUI-specific tools (1password, kitty, claude).

## Development Workflow

1. Edit configurations in appropriate package directory
2. Test with `stow <package>` or `stow -R <package>`
3. For system-level changes, update corresponding Ansible role in `ansible/roles/<role>/tasks/main.yml`
4. Validate Ansible changes with `--check --diff` before applying
5. Use Ansible playbooks for complete environment provisioning

## Installation Prerequisites

- Python3 and pip (pre-installed on Fedora)
- Ansible: `sudo dnf install ansible`
- Git
- GNU Stow
