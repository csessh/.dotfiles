####################################################################
#  HELPER SCRIPTS 
####################################################################
nah() {
    git reset --hard

    if [[ $1 == "-f" ]]; then
        git clean -df
    fi
}

snipe() {
    ps aux | fzf --height=40% --layout=reverse --prompt="Which process are we killing? > " | awk '{print $2}' | xargs -r sudo kill
}

activate() {
    source .venv/bin/activate
}

zeload() {
    source ~/.zshrc
}

petprev() {
    PREV=$(fc -lrn | head -n 1)
    sh -c "pet new -t `printf %q "$PREV"`"
}

