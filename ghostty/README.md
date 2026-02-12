# ghostty

GPU-accelerated terminal emulator.

## Configuration

```bash
cd ~/.dotfiles
stow ghostty
```

**Note**: Ghostty is installed via native package manager (dnf/apt) for OpenGL compatibility, not Nix.

## Settings

| Setting | Value |
|---------|-------|
| Theme | Cyberdream |
| Font | CommitMono Regular, 16pt |
| Term | xterm-256color |
| Cursor | Block, blinking |
| Scrollback | 5000 lines |
| Shell integration | zsh |

## Features

- Fullscreen by default, no window decorations
- Mouse hides while typing
- Copy-on-select to clipboard
- Clipboard paste protection
- Trailing space trimming on clipboard
- VSync enabled

## Keybindings

- `Shift+Enter`: Insert literal newline

## Theme

Custom Cyberdream theme located in `themes/cyberdream`.
