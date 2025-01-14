# Bat: a cat clone with wings

[bat](https://github.com/sharkdp/bat) is cat(1) clone with syntax highlighting and git integration.

It's absolutely incredible, except typing cat has already become permanent muscle memory.

```bash
alias cat='bat'
```

This alias is included in [zshrc](./shell/.oh-my-zsh/custom/alias.zsh).

## Configuration

```bash
cd ~/.dotfiles
stow bat
```

## Themes

``` bash
bat cache --build
```

If there are any custom themes placed in `~/.config/bat/`, `bat` will write them to cache.

To get a list of available themes:
``` bash
bat --list-themes
```

The current theme is: `Cyberdream`.
