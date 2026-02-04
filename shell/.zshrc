export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export PATH=/home/linuxbrew/.linuxbrew/bin/:$PATH

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

ZSH_THEME="tdo"

# SSH agent to load SSH PIV public key from Yubikey
# Only once per session
if ! ssh-add -l 2>/dev/null | grep -q "PIV AUTH pubkey"; then
    OPENSC_PKCS11=""
    for lib in \
        "$HOME/.local/lib/opensc-pkcs11.so" \
        "$HOME/.nix-profile/lib/opensc-pkcs11.so" \
        "/opt/homebrew/lib/opensc-pkcs11.so" \
        "/usr/local/lib/opensc-pkcs11.so" \
        "/usr/lib64/opensc-pkcs11.so" \
        "/usr/lib/x86_64-linux-gnu/opensc-pkcs11.so" \
        "/usr/lib/aarch64-linux-gnu/opensc-pkcs11.so"; do
        if [ -f "$lib" ]; then
            OPENSC_PKCS11="$lib"
            break
        fi
    done
    [ -n "$OPENSC_PKCS11" ] && ssh-add -s "$OPENSC_PKCS11" 2>/dev/null
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
eval "$(zoxide init --cmd cd zsh)"
eval "$(uv generate-shell-completion zsh)"
