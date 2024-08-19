# Todoist

I have tried so many different TODO apps, none comes close to Todoist.

## todoist CLI

The [CLI client](https://github.com/sachaos/todoist) isn't an officially supported by Todoist themselves.

## Integration API token

Todoist API token is generated and placed in 1Password `/dev/null` vault.

To avoid exposing this API to the public, we use a config template to inject secrets from 1Password:

```bash
cd ~/.dotfiles/todoist
op inject -i template.json -o ~/.config/todoist/config.json

cd ~/.config/todoist
chmod 600 config.json
```

`op inject` will create a new file, not a symlink, in `~/.config/todoist` directory.

*NOTE:* todoist CLI, written in Go, expects a very specific file permission (600).
It doesn't like symlinks for that reason.
