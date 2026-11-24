# claude

Claude Code user config. `stow claude` links:

- `~/.claude/CLAUDE.md` and `~/.claude/RTK.md`: global instructions
- `~/.config/ccstatusline/settings.json`: status line

Run `mkdir -p ~/.claude ~/.config/ccstatusline` before a manual `stow claude` (`bootstrap.sh` does this on NixOS). If `~/.claude` doesn't exist, stow links the whole directory into this repo and Claude Code's credentials and history would be written here.

`~/.claude/settings.json` is deliberately not tracked: it holds machine- and employer-specific settings.

## Status line

[ccstatusline](https://github.com/sirmalloc/ccstatusline) config for the Claude Code status line.

`stow claude` links `~/.config/ccstatusline/settings.json` here. Changes made in ccstatusline's settings UI are written through the symlink (it resolves symlinks and writes atomically next to the target), so they land in this repo.

Claude Code runs it via `~/.claude/settings.json`:

```json
"statusLine": { "type": "command", "command": "npx -y ccstatusline@latest", "padding": 0 }
```
