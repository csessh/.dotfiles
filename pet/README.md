# Pet - gist/code snippet managment

## Configuration

```bash
cd ~/.dotfiles
stow pet
```

## Keybinds and supporting functions

See [zsh's scripts](./shell/.oh-my-zsh/custom/scripts.zsh) for the implementation.

* `<C-s>` brings up a `pet search` prompt to look up existing snippets. Much like how `<C-r>` lets you search `history`. 

* `prev` command lets you `pet new` the previously executed command in the current terminal buffer.
