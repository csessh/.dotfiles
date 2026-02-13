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

## Key Bindings

Prefix: `C-Space` (Ctrl+Space)

### Pane Navigation

| Binding | Action |
|---------|--------|
| `<prefix>h` | Select pane left |
| `<prefix>j` | Select pane down |
| `<prefix>k` | Select pane up |
| `<prefix>l` | Select pane right |
| `C-h/j/k/l` | Seamless nvim/tmux navigation (vim-tmux-navigator) |

### Pane Management

| Binding | Action |
|---------|--------|
| `<prefix>H` | Swap pane left |
| `<prefix>J` | Swap pane down |
| `<prefix>K` | Swap pane up |
| `<prefix>L` | Swap pane right |
| `M-h/j/k/l` | Resize pane by 5 units (no prefix) |

### Splits

| Binding | Action |
|---------|--------|
| `<prefix>s` | Horizontal split (preserves cwd) |
| `<prefix>v` | Vertical split (preserves cwd) |

### Session Management (tmux-resurrect)

| Binding | Action |
|---------|--------|
| `<prefix>C-s` | Save session |
| `<prefix>C-r` | Restore session |

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
