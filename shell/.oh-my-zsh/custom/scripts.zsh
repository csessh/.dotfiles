####################################################################
#  HELPER SCRIPTS 
####################################################################
nah() {
    git reset --hard

    if [[ $1 == "-f" ]]; then
        git clean -df
    fi
}

activate() {
    source .venv/bin/activate
}

zeload() {
    source ~/.zshrc
}

prev() {
    PREV=$(fc -lrn | head -n 1)
    sh -c "pet new -t `printf %q "$PREV"`"
}

