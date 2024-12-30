export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH
export PATH=/home/linuxbrew/.linuxbrew/bin/:$PATH
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
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
source <(fzf --zsh)

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(zoxide init --cmd cd zsh)"

# xterm-kitty ssh woe
# https://www.reddit.com/r/KittyTerminal/comments/13ephdh/xtermkitty_ssh_woes_i_know_about_the_kitten_but/
[[ "$TERM" == "xterm-kitty" ]] && alias ssh="TERM=xterm-256color ssh" 
