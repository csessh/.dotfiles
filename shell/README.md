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
| `dps` | dockerps |
| `wscat` | websocat |
| `tree` | tree -Cap -I ".git" |

## Functions

| Function | Description |
|----------|-------------|
| `box A\|B\|F\|P` | Look up an EC2 box by name |
| `nah [-f]` | Git reset (with -f: clean untracked) |
| `snipe` | Kill process via fzf |
| `piv` | Restart ssh-agent and reload the Yubikey PIV key |
| `zeload` | Reload zshrc |
| `mkd <dir>` | mkdir + cd |
| `paths` | List PATH entries |
| `dockerps` | Formatted docker ps |
| `filesize` | Sorted file sizes |
| `today` | Current date |
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

On shell startup, `.zshrc` loads the Yubikey PIV key into ssh-agent via `ssh-add -s`, unless it is already loaded. It uses the opensc library that the workstation's home-manager links at `~/.local/lib/opensc-pkcs11.so`; servers have none and skip this. If SSH fails with "agent refused operation", run `piv`.

## Dependencies

Oh-my-zsh must be installed:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
