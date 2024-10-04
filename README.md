# Dotfiles

This repo contains my own dev configuration files, a.k.a dotfiles.

Depending on the OS, required package manager(s) may be different.
This instruction was drafted with: `dnf` and `Homebrew`.

Linux distro of choice: Fedora 40.

## Fonts

It can be any [Nerd Fonts](https://www.nerdfonts.com/).
The current favourite is [CommitMono](https://commitmono.com/).

```bash
wget -P ~/.local/share/fonts https://github.com/eigilnikolajsen/commit-mono/releases/download/v1.143/CommitMono-1.143.zip \
&& cd ~/.local/share/fonts \
&& unzip CommitMono.zip \
&& rm CommitMono.zip \
&& fc-cache -fv
```

*NOTE*: It's fairly important to note that some [Neovim](./nvim)'s plugins require nerd font glyphs to display filetype icons.

## GNU Stow

[Stow](https://www.gnu.org/software/stow/) is widely available on most package manager.

```bash
sudo dnf install stow
```

[Stow](https://www.gnu.org/software/stow/) creates symlinks for each dotfile and places them appropriately under `~` directory.

> GNU Stow is a symlink farm manager which takes distinct packages of software and/or data located in separate directories on the filesystem, and makes them appear to be installed in the same place. For example, /usr/local/bin could contain symlinks to files within /usr/local/stow/emacs/bin, /usr/local/stow/perl/bin etc., and likewise recursively for any other subdirectories such as .../share, .../man, and so on.

> This is particularly useful for keeping track of system-wide and per-user installations of software built from source, but can also facilitate a more controlled approach to management of configuration files in the user's home directory, especially when coupled with version control systems.

Nothing more is required.
Changes made to configuration files under `~/.dotfiles` will be automatically detected by services/applications.
Some application may require `source` to reload.

## dotfiles

It's best to setup and configure the environment in the following order:

1. [kitty terminal](./kitty/README.md)
2. [ZSH](./shell/README.md)
3. [brew](./brew/README.md)
4. [bat](./bat/README.md)
5. [git](./git/README.md)
6. [lazygit](./lazygit/README.md)
7. [Neovim](./nvim/README.md)
8. [1Password](./1password/README.md)
9. [pet](./pet/README.md)

## configs containing secrets

Some configs may contain secrets such as username/password or API access token.

Secret injection can be done with 1Password CLI. See [1Password](./1password) for more information.

* [todoist](./todoist)
