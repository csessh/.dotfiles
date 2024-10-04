# Pet - gist/code snippet managment

## Secret

The configuration for Pet employs an access token for GitHub Gist.

This access token is stored in 1Password vault. A secret injection step is required to ensure this secret stays secret.

```bash
cd ~/.dotfiles/pet/.config/pet
op inject -i config-template.toml -o config.toml
```

**NOTE:** `config.toml` is included in `.gitignore`.

## GitHub Gist

Command snippets are sync'd to this [GitHub Gist](https://gist.github.com/csessh/307fa561001fb7f5d235ca1ab4839191).

## Configuration

```bash
cd ~/.dotfiles
stow pet
```

## Keybinds and supporting functions

See [zsh's scripts](../shell/.oh-my-zsh/custom/scripts.zsh) for the implementation.

* `<C-s>` brings up a `pet search` prompt to look up existing snippets. Much like how `<C-r>` lets you search `history`.

* `prev` command lets you `pet new` the previously executed command in the current terminal buffer.

