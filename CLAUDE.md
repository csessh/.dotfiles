# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository managed with GNU Stow and automated with Ansible. It contains configuration files for various development tools and applications on a Fedora Linux system.

## Architecture

The repository follows a structured approach with two main management systems:

### GNU Stow Structure
- Each tool has its own directory (e.g., `nvim/`, `tmux/`, `shell/`, `git/`)
- Configurations are organized to mirror the target filesystem structure
- Use `stow <package>` from the repository root to deploy configurations

### Ansible Automation
- Located in `ansible/` directory
- Playbooks for local (`localhost.yml`) and remote (`remote.yml`) deployment
- Role-based organization under `ansible/roles/`
- Vault file for secrets management (ignored by git)

## Common Commands

### Ansible Deployment
```bash
cd ~/.dotfiles/ansible

# With vault file present:
ansible-playbook localhost.yml --become-pass-file vault --vault-pass-file vault

# Without vault file:
ansible-playbook localhost.yml --ask-become-pass --ask-vault-pass

# Remote deployment:
ansible-playbook remote.yml -i "<address>," --become-pass-file vault --vault-pass-file vault
```

### GNU Stow Package Management
```bash
cd ~/.dotfiles
stow nvim      # Deploy neovim configuration
stow tmux      # Deploy tmux configuration
stow shell     # Deploy zsh configuration
stow <package> # Deploy any package configuration
```

### Neovim Development
- LSP management: `:Mason` to install/manage LSPs, linters, formatters
- Required external dependencies: fzf, ripgrep, fd, xclip
- Configured LSPs: bashls, clangd, docker_compose_language_service, dockerls, lua_ls, markdown_oxide, pyright, ruff, taplo, ts_ls
- Auto-formatters: stylua (Lua), isort+ruff_format (Python), eslint_d (TypeScript)

### Tmux Setup
- Plugin manager: TPM installation required
- Key plugin: tmux-resurrect for session persistence
- Seamless neovim-tmux navigation with Ctrl+hjkl

## Key Components

- **Neovim**: Lua-based configuration with LSP, formatting, and extensive plugin ecosystem
- **Shell**: zsh with oh-my-zsh framework
- **Tmux**: Session management with plugin support and neovim integration
- **Git**: Version control configuration
- **Terminal**: kitty and ghostty terminal configurations
- **Development Tools**: bat, lazygit, pet, fastfetch, 1Password CLI integration

## Installation Dependencies

### System Requirements
- Python3 and pip (usually pre-installed on Fedora)
- Ansible: `sudo dnf install ansible`
- Git for repository management
- GNU Stow for dotfile deployment

### Tool-Specific Dependencies
- **zsh setup**: oh-my-zsh installation script
- **tmux**: TPM plugin manager from GitHub
- **neovim**: Mason for LSP/formatter management
- **External tools**: fzf, ripgrep, fd, xclip for full neovim functionality

## Development Workflow

1. Make configuration changes in the appropriate package directory
2. Test locally with `stow <package>` 
3. For system-wide changes, update the corresponding Ansible role
4. Use Ansible playbooks for complete environment setup on new systems
5. Commit changes to git for version control

The repository supports both individual package deployment (Stow) and complete system automation (Ansible), making it suitable for both incremental updates and full environment provisioning.