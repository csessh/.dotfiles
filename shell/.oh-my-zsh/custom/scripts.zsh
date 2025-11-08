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

keychron() {
    PERM=600
    if [[ $1 == "-u" ]]; then
        PERM=777
    fi

    for i in {0..6}; do
        sudo chmod $PERM /dev/hidraw$i
    done
    ls -la /dev | grep hidraw
}

mkd() {
    mkdir -p -- "$1";
    cd "$1";
}

trim() {
    sed 's/^[ \t]*//;s/[ \t]*$//'
}

rgrep() {
	grep -Id recurse "$@"
}

today() {
    date '+%Y-%m-%d'
}

paths() {
	echo $PATH | tr ':' '\n'
}

filesize() {
	du -sk * | sort -h
}

