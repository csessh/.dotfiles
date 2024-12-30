# SHELL

## zsh and oh-my-zsh

```bash
sudo dnf install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Choose the default option and skip `.zshrc` creation step.

## Plugins

`zsh-autosuggestions` plugin requires additonal step to install.

``` bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

Other plugins work out of the box.

## .zshrc

```bash
cd ~/.dotfiles
stow shell
```

ba da bing, ba da boom!! It can't be any easier.
