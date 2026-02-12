# shell

Zsh configuration with oh-my-zsh and zinit.

## Configuration

```bash
cd ~/.dotfiles
stow shell
```

## Structure

```
shell/
├── .zshrc                    # Main config
└── .oh-my-zsh/custom/
    ├── alias.zsh             # Aliases
    ├── history.zsh           # History settings
    ├── keymaps.zsh           # Key bindings
    ├── scripts.zsh           # Helper functions
    └── themes/tdo.zsh-theme  # Custom prompt
```

## Plugins

**Zinit plugins**:
- zsh-syntax-highlighting
- zsh-completions
- zsh-autosuggestions

**Oh-my-zsh plugins**:
- sudo
- web-search
- colored-man-pages
- git

## Shell Integrations

- **fzf**: Fuzzy finder
- **zoxide**: Smart directory jumper (`cd` is aliased to zoxide)
- **docker**: Command completion
- **uv**: Python package manager completion

## Aliases

| Alias | Command |
|-------|---------|
| `cat` | bat |
| `vim`, `v` | nvim |
| `lazy` | lazygit |
| `tmx` | tmux |
| `stwo` | stow |
| `tree` | tree -Cap -I ".git" |

## Functions

| Function | Description |
|----------|-------------|
| `nah [-f]` | Git reset (with -f: clean untracked) |
| `snipe` | Kill process via fzf |
| `activate` | Source .venv/bin/activate |
| `zeload` | Reload zshrc |
| `mkd <dir>` | mkdir + cd |
| `paths` | List PATH entries |
| `dockerps` | Formatted docker ps |
| `filesize` | Sorted file sizes |
| `today` | Current date |
| `keychron [-u]` | Set hidraw permissions |
| `trim` | Strip whitespace |
| `rgrep` | Recursive grep |

## Keybindings

| Binding | Action |
|---------|--------|
| `Ctrl+P` | History search backward |
| `Ctrl+N` | History search forward |
| `Ctrl+Z` | Foreground (fg) |

## History

- Size: 5000 entries
- Deduplication enabled
- Shared across sessions
- Commands starting with space are ignored

## Yubikey PIV

On shell startup, `.zshrc` loads the Yubikey PIV key into ssh-agent via `ssh-add -s`. The opensc library is installed via native package manager for ABI compatibility.

## Dependencies

Oh-my-zsh must be installed:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
