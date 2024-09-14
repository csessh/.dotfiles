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
        ls ~/pyenvs 
    else
        source ~/pyenvs/$1/bin/activate
    fi
}

