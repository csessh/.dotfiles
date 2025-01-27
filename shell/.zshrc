export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH
export PATH=/home/linuxbrew/.linuxbrew/bin/:$PATH
export ZSH=$HOME/.oh-my-zsh
export UPDATE_ZSH_DAYS=14
export LANG=en_US.UTF-8
export EDITOR="nvim"

ZSH_THEME="afowler_modified"

# Plugins and snippets
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit ice depth=1
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

autoload -U compinit && compinit
zinit cdreplay -q

plugins=(sudo web-search command-not-found colored-man-pages git)

# Source custom configuration
source $ZSH/oh-my-zsh.sh

# Shell integrations
source <(fzf --zsh)
source <(docker completion zsh)
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(uv generate-shell-completion zsh)"

# xterm-kitty ssh woe
# https://www.reddit.com/r/KittyTerminal/comments/13ephdh/xtermkitty_ssh_woes_i_know_about_the_kitten_but/
[[ "$TERM" == "xterm-kitty" ]] && alias ssh="TERM=xterm-256color ssh" 
