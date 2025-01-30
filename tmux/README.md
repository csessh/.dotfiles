# tmux

## Configuration 

```bash
cd ~/.dotfiles
stow tmux
```

## Plugin manager: TPM

As per [TPM installation guide](https://github.com/tmux-plugins/tpm?tab=readme-ov-file#installation): 

``` bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## Plugins

The most important and essential plugin is [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect).

Standard keybinds apply:

- `<prefix><C+s>` to save sessions to disk.
- `<prefix><C+r>` to restore sessions.

## Screensaver mode

`tmux` starts `cmatrix` after x seconds. Just because.

