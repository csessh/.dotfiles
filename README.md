# Dotfiles 

This repo contains my own dev configuration files, a.k.a dotfiles.

Depending on the OS, required package manager(s) may be different. This instruction was drafted with: `dnf` and `Homebrew`.

# Instructions 

## 0 - Fonts 

It can be any [Nerd Fonts](https://www.nerdfonts.com/). The current favourite is JetBrains Mono.

```
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
&& cd ~/.local/share/fonts \
&& unzip JetBrainsMono.zip \
&& rm JetBrainsMono.zip \
&& fc-cache -fv
```

## 1 - Install zsh and oh-my-zsh

```
sudo dnf install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Choose the default option and skip `.zshrc` creation step.

## 2 - Stow 

Before install `stow`, clone `.dotfiles` repo from github:

```
cd ~
git clone git@github.com:csessh/.dotfiles.git
```

Note: if haven't already, ensure `~/.ssh/config` exists and the private key are present.

Once the repo is cloned, install `stow`:

```
sudo dnf install stow
stow nvim
stow shell
... so on ... 
```

Stow creates symlinks for each dotfile and places them appropriately under `~` directory. 

Nothing more is required. Changes made to configuration files under `~/.dotfiles` will be detected. Some application may require `source`. 

```
source ~/.zshrc
```

## 3 - NeoVim 


Open `nvim` and let `Lazy` install all required plugins. 

Open `Mason` and install requied linters and formatters:

```
:Mason
```

The list of linters and formatters can be found in [nonels](/nvim/.config/nvim/lua/plugins/nonels.lua).

## 4 - Homebrew

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
... follow brew installation instruction ... 

```

Once `Homebrew` is installed, run the following command to install packages listed in `~/Brewfile`:

```
brew bundle install 
```

# Optional: i3 tiling window manager 

## Install i3wm

```
sudo dnf install i3
```

This requires a system restarts and `i3` has to be selected as default at the login screen.

## Configuration 

Configuration file is stowed under `~/.dotfiles` directory along with the others.

```
stow i3wm
```

## Install nitrogen 

Nitrogen is used to set wallpaper. No configuration is required.

```
sudo dnf install nitrogen
```

## Multiple displays

Yep. that's another thing to get "right".

If `xrandr` isn't already present:

```
sudo dnf install xrandr
```

This bit can be a little fiddly. Depending on the external monitor resolution, the config value may differ:

```
# Mirror display
xrandr --output <<output source (HDMI | DP-[0-9] |)>> --mode <<screen resolution>>

# Turn off laptop screen
xrandr --output eDP-1 --off 
```
