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

####################################################################
#  KEYBINDING
####################################################################
bindkey -s "^Z" "fg^M"

####################################################################
#  ALIAS
####################################################################
alias cat="bat"
alias tree='tree -Cap -I ".git"'
alias vim="nvim"
alias claer="clear"

####################################################################
#  FUNCTIONS 
####################################################################
sniper() {
    ps aux | fzf --height=40% --layout=reverse --prompt="Which process are we killing? > " | awk '{print $2}' | xargs -r sudo kill
}

nah() {
    git reset --hard

    if [[ $1 == "-f" ]]; then
        git clean -df
    fi
}

activate() {
    if [ -z "$1" ]; then
        echo "virtualenv name is required."
        echo "Select one of the following to source:"
        ls ~/Documents/pyenvs 
    else
        source ~/Documents/pyenvs/$1/bin/activate
    fi
}

