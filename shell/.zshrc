export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH
export ZSH=$HOME/.oh-my-zsh
export UPDATE_ZSH_DAYS=14
export LANG=en_US.UTF-8
export EDITOR="nvim"

ZSH_THEME="afowler"
HIST_STAMPS="dd/mm/yyyy"
plugins=(
    colored-man-pages
    git
    sudo
)

source $ZSH/oh-my-zsh.sh

eval "$(zoxide init --cmd cd zsh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

