# no reason why I would use simple cd
@cd() {
    pushd > /dev/null "$*"
}


# creates a directory and enters it
@mkcd() {
    mkdir -p "$@" && @cd "$@"
}


@toggle() {
    if [ $(ps cax | grep "$1" | wc -l) -gt 0 ]
    then
        killall "$1"
    else
        $1 "${@:2}"
    fi
}
