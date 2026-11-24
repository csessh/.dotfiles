# claude

[ccstatusline](https://github.com/sirmalloc/ccstatusline) config for the Claude Code status line.

`stow claude` links `~/.config/ccstatusline/settings.json` here. Changes made in ccstatusline's settings UI are written through the symlink (it resolves symlinks and writes atomically next to the target), so they land in this repo.

Claude Code runs it via `~/.claude/settings.json`:

```json
"statusLine": { "type": "command", "command": "npx -y ccstatusline@latest", "padding": 0 }
```
