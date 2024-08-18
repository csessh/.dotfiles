# Dotfiles

This repo contains my own dev configuration files, a.k.a dotfiles.

Depending on the OS, required package manager(s) may be different.
This instruction was drafted with: `dnf` and `Homebrew`.

## Instructions

### 0 - Fonts

It can be any [Nerd Fonts](https://www.nerdfonts.com/).
The current favourite is JetBrains Mono Nerd Font.

```bash
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
&& cd ~/.local/share/fonts \
&& unzip JetBrainsMono.zip \
&& rm JetBrainsMono.zip \
&& fc-cache -fv
```

### 1 - Install zsh and oh-my-zsh

```bash
sudo dnf install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Choose the default option and skip `.zshrc` creation step.

### 2 - Stow

Before install `stow`, clone `.dotfiles` repo from github:

```bash
cd ~
git clone git@github.com:csessh/.dotfiles.git
```

Note: if haven't already, ensure `~/.ssh/config` exists and the private key are present.

Once the repo is cloned, install `stow`:

```bash
sudo dnf install stow
stow nvim
stow shell
... so on ... 
```

Stow creates symlinks for each dotfile and places them appropriately under `~` directory.

Nothing more is required.
Changes made to configuration files under `~/.dotfiles` will be detected.
Some application may require `source`.

```bash
source ~/.zshrc
```

### 3 - NeoVim

Open `nvim` and let `Lazy` install all required plugins.

Open `Mason` and install requied linters and formatters:

```vim
:Mason
```

The list of linters and formatters can be found in [nonels](/nvim/.config/nvim/lua/plugins/nonels.lua).

Additionally, in order to properly enable nvim-treesitter `auto_install` option:

```bash
npm install tree-sitter-cli
```

### 4 - Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
... follow brew installation instruction ... 

```

Once `Homebrew` is installed, run the following command:

```bash
brew bundle install 
```

### 1Password

This section outlines the steps required to enable 1Password CLI by
following this official [guide](https://developer.1password.com/docs/cli/get-started/).

```bash
stow 1password
```

Simple enough.

### Tools with secrets

Tools that require secret injection are not managed with stow.

#### todoist

```bash
cd ~/.dotfiles/todoist
op inject -i template.json -o ~/.config/todoist/config.json
```
