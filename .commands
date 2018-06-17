# no reason why I would use simple cd
function cd() {
    pushd > /dev/null "$*"
}


# creates a directory and enters it
function mkcd() {
    mkdir -p "$@" && cd "$@"
}
