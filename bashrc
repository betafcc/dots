alias emacs='XLIB_SKIP_ARGB_VISUALS=1 emacs -nw'
export EDITOR='subl -w'


# no reason why I would use simple cd
function cd() {
    pushd > /dev/null "$*"
}


# creates a directory and enters it
function @mkcd() {
    mkdir -p "$@" && cd "$@"
}


# opens a temporary file then pipes the content when closed
function @edit() {
    tempfile=$(mktemp --suffix "$*")
    $EDITOR $tempfile
    cat $tempfile
}
