export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export PATH=/home/linuxbrew/.linuxbrew/bin/:$PATH
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.foundry/bin:$PATH"

# Nix
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi
if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi
export PATH="$HOME/.nix-profile/bin:$PATH"

export UPDATE_ZSH_DAYS=28
export LANG=en_US.UTF-8
export EDITOR="nvim"
export F="$HOME/.dotfiles/home-manager/.config/home-manager/"

ZSH_THEME="tdo"

# Load the Yubikey PIV key into ssh-agent when the key is plugged in and not loaded yet.
# The workstation's home-manager links opensc here; servers have no opensc and skip this.
OPENSC_PKCS11="$HOME/.local/lib/opensc-pkcs11.so"
if [ -f "$OPENSC_PKCS11" ] && ! ssh-add -l 2>/dev/null | grep -q "PIV AUTH pubkey" &&
    pkcs11-tool --module "$OPENSC_PKCS11" --list-slots 2>/dev/null | grep -q "Slot"; then
    ssh-add -s "$OPENSC_PKCS11"
fi

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

plugins=(sudo web-search colored-man-pages git)

# Source custom configuration
source $HOME/.oh-my-zsh/oh-my-zsh.sh

# Shell integrations
source <(fzf --zsh)
source <(docker completion zsh)
eval "$(uv generate-shell-completion zsh)"
eval "$(zoxide init --cmd cd zsh)"
