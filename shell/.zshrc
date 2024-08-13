export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH=$HOME/.oh-my-zsh
export UPDATE_ZSH_DAYS=14
export LANG=en_US.UTF-8
export EDITOR='nvim'

ZSH_THEME="bira"
HIST_STAMPS="mm/dd/yyyy"
plugins=(git tldr sudo)

source $ZSH/oh-my-zsh.sh

alias cat='bat'
alias tree='tree -Cap'
alias vim='nvim'

eval "$(zoxide init --cmd cd zsh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
