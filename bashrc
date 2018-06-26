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
    $EDITOR $tempfile 2>/dev/null
    cat $tempfile
}


# keep redoing $action after waiting $delay 
function @monitor() {
    delay="$1"
    action="${@:2}"
    while true
    do
            eval "$action"
            sleep "$delay"
    done
}


# executes $command after every change in $files
function @watch() {
    command="$1"
    files="${@:2}"
    while true
    do
        eval "$command"
        inotifywait -qqe close_write $files
    done
}
