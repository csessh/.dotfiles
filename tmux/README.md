# tmux

Terminal multiplexer configuration.

## Configuration

```bash
cd ~/.dotfiles
stow tmux
```

## Plugin Manager

[TPM](https://github.com/tmux-plugins/tpm) (Tmux Plugin Manager):
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## Plugins

- **tmux-mode-indicator**: Visual mode indicator
- **vim-tmux-navigator**: Seamless nvim/tmux navigation
- **tmux-better-mouse-mode**: Enhanced mouse support
- **tmux-resurrect**: Session persistence

## Theme

Cyberdream color palette with custom mode indicators:
- Green: Normal
- Yellow: Wait/Prefix
- Yellow (bright): Copy mode
- Red: Sync mode

## Prefix

`C-Space` (Ctrl+Space)

## Keybindings

### Pane Navigation
| Binding | Action |
|---------|--------|
| `<prefix>h/j/k/l` | Select pane (vim-style) |
| `<prefix>H/J/K/L` | Swap pane |
| `M-h/j/k/l` | Resize pane (no prefix) |
| `C-h/j/k/l` | Seamless nvim/tmux navigation |

### Splits
| Binding | Action |
|---------|--------|
| `<prefix>s` | Horizontal split |
| `<prefix>v` | Vertical split |

### Session Management
| Binding | Action |
|---------|--------|
| `<prefix>C-s` | Save session (resurrect) |
| `<prefix>C-r` | Restore session (resurrect) |

### Other
| Binding | Action |
|---------|--------|
| `<prefix>r` | Reload config |
| `<prefix>Enter` | Toggle synchronize-panes |

## Settings

- **Index**: Starts at 1
- **Mouse**: Enabled
- **Status bar**: Top
- **Scroll speed**: 1 line per scroll
- **Escape time**: 1ms (for nvim compatibility)

## Screensaver

After 15 minutes of inactivity, `cmatrix` runs as a screensaver.

## Dependencies

Installed via Nix home-manager (see `home-manager/.config/home-manager/packages.nix`).
