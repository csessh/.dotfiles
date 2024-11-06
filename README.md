# Dotfiles

This repo contains configuration files, a.k.a dotfiles, for my Raspberry Pi.

The current setup:
- Linux distro: Raspberry Pi OS / Debian 12
- Headless server

## GNU Stow

```bash
sudo apt install stow
```

[Stow](https://www.gnu.org/software/stow/) creates symlinks for each dotfile and places them appropriately under `~` directory.

> GNU Stow is a symlink farm manager which takes distinct packages of software and/or data located in separate directories on the filesystem, and makes them appear to be installed in the same place. For example, /usr/local/bin could contain symlinks to files within /usr/local/stow/emacs/bin, /usr/local/stow/perl/bin etc., and likewise recursively for any other subdirectories such as .../share, .../man, and so on.
> This is particularly useful for keeping track of system-wide and per-user installations of software built from source, but can also facilitate a more controlled approach to management of configuration files in the user's home directory, especially when coupled with version control systems.

Nothing more is required.
Changes made to configuration files under `~/.dotfiles` will be automatically detected by services/applications.
Some application may require `source` to reload.

## Pre-requisites

### Dependencies

- [fzf](https://github.com/junegunn/fzf)
- [fd](https://github.com/sharkdp/fd)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [openssl](https://github.com/openssl/openssl)
- [xclip](https://github.com/astrand/xclip)

Most of them are installable with `apt`, however, some must be built from source.

### Programming languages

- Python
- Go

## dotfiles

It's best to setup and configure the environment in the following order:

1. [ZSH](./shell/README.md)
2. [bat](./bat/README.md)
3. [git](./git/README.md)
4. [lazygit](./lazygit/README.md)
5. [Neovim](./nvim/README.md)
6. [pet](./pet/README.md)

## Fonts (Optional)

It can be any [Nerd Fonts](https://www.nerdfonts.com/).
The current favourite is [CommitMono](https://commitmono.com/).

```bash
wget -P ~/.local/share/fonts https://github.com/eigilnikolajsen/commit-mono/releases/download/v1.143/CommitMono-1.143.zip \
&& cd ~/.local/share/fonts \
&& unzip CommitMono-1.143.zip \
&& rm CommitMono-1.143.zip \
&& fc-cache -fv
```

*NOTE*: Fonts are optional as the Pi is rarely connected to a monitor. Everything is done via `ssh`.

