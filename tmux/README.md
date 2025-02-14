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

## Tmux - Neovim navigation

Navigation between panes is incredibly easy with the help of [nvim-tmux-navigation](https://github.com/alexghergh/nvim-tmux-navigation).


This plugin requires setups on both Tmux and Neovim configurations:
- [Neovim's side](../nvim/.config/nvim/lua/plugins/tmux-nvim-navigation.lua)
- [Tmux's side](./.tmux.conf)


Ultimately, navigation is just this simple:

- `<C-h>` to navigate to the left pane
- `<C-j>` to navigate to the pane below
- `<C-k>` to navigate to the pane above
- `<C-l>` to navigate to the right pane

## Screensaver mode

`tmux` starts `cmatrix` after x seconds. Just because.

