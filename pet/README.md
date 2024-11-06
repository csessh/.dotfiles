# Pet - gist/code snippet managment

[Pet](https://github.com/knqyf263/pet) is a simple command-line snippet manager.

## Installation

```bash
wget https://github.com/knqyf263/pet/releases/download/v<version>/pet_<version>_linux_arm64.deb
dpkg -i pet_<version>_linux_arm64.deb
```

## Secret

The configuration for Pet employs an access token for GitHub Gist.

This access token is stored in 1Password `/dev/null/` vault. 

```bash
cd ~/.dotfiles/pet/.config/pet
cp config-template.toml ~/.config/pet/config.toml
```

Edit `config.toml` and replace the token placeholder with GitHub Gist access token.

```bash
vim ~/.config/pet/config.toml
```

## GitHub Gist

Command snippets are sync'd to this [GitHub Gist](https://gist.github.com/csessh/307fa561001fb7f5d235ca1ab4839191).

## Keybinds and supporting functions

See [zsh's scripts](../shell/.oh-my-zsh/custom/scripts.zsh) for the implementation.

* `<C-s>` brings up a `pet search` prompt to look up existing snippets. Much like how `<C-r>` lets you search `history`.

* `prev` command lets you `pet new` the previously executed command in the current terminal buffer.

