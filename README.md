# Dotfiles

This repo contains my own dev configuration files, a.k.a dotfiles.

Depending on the OS, required package manager(s) may be different.
This instruction was drafted with: `dnf` and `Homebrew`.

Linux distro of choice: Fedora 40.

## Fonts

It can be any [Nerd Fonts](https://www.nerdfonts.com/).
The current favourite is [JetBrains Mono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip).

```bash
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
&& cd ~/.local/share/fonts \
&& unzip JetBrainsMono.zip \
&& rm JetBrainsMono.zip \
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

1. [kitty terminal](./kitty)
2. [ZSH](./shell)
3. [brew](./brew)
4. [bat](./bat)
5. [git](./git)
6. [Neovim](./nvim)
7. [1Password](./1password)

## configs containing secrets

Some configs may contain secrets such as username/password or API access token.

Secret injection can be done with 1Password CLI. See [1Password](./1password) for more information.

* [todoist](./todoist)
