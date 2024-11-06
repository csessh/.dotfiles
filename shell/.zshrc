export PATH=$HOME/bin:/usr/bin/:/usr/local/bin:$HOME/.local/bin:$PATH
export ZSH=$HOME/.oh-my-zsh
export UPDATE_ZSH_DAYS=14
export LANG=en_US.UTF-8
export EDITOR="nvim"

ZSH_THEME="afowler"
HIST_STAMPS="%d/%m/%y %T"
plugins=(
    colored-man-pages
    git
    sudo
)

source $ZSH/oh-my-zsh.sh
source $HOME/.cargo/bin

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init --cmd cd zsh)"
