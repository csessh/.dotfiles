# SHELL

## zsh and oh-my-zsh

```bash
sudo dnf install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Choose the default option and skip `.zshrc` creation step.

## .zshrc

```bash
cd ~/.dotfiles
stow shell
```

ba da bing, ba da boom!! It can't be any easier.
