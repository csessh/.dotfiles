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
    if [ -z "$1" ]; then
        echo "virtualenv name is required. Select one to source:"
        ls ~/pyenvs 
    else
        source ~/pyenvs/$1/bin/activate
    fi
}

prev() {
  PREV=$(fc -lrn | head -n 1)
  sh -c "pet new `printf %q "$PREV"`"
}

pet-search() {
  BUFFER=$(pet search --color --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N pet-search
stty -ixon
