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

zeload() {
    source ~/.zshrc
}

piv() {
    systemctl --user restart ssh-agent && ssh-add -s ~/.local/lib/opensc-pkcs11.so
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
  date '+%d %B %Y'
}

paths() {
	echo $PATH | tr ':' '\n'
}

filesize() {
    {
        echo "SIZE FILENAME"
        du -sh * | sort -h
    } | column -t
}

dockerps() {
    docker ps -a --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}"
}

box() {
  [[ $1 == [AaBbFfPp] ]] || { echo "usage: box A|B|F|P" >&2; return 1; }
  local name="box-${(L)1}" id
  id=$(aws ec2 describe-instances --profile A3 --region ap-northeast-1 \
    --filters "Name=tag:Name,Values=$name" "Name=tag:Project,Values=hyperprop" "Name=instance-state-name,Values=running" \
    --query 'Reservations[].Instances[].InstanceId' --output text) || return
  [[ -n $id ]] || { echo "no running $name" >&2; return 1; }
  # session-manager-plugin cannot resolve `aws login` profiles; hand it exported credentials
  eval "$(aws configure export-credentials --profile A3 --format env)" || return
  aws ssm start-session --region ap-northeast-1 --target "$id"
  unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_CREDENTIAL_EXPIRATION
}
