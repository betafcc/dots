# -nw for emacs means 'no-window'
alias emacs='TERM=xterm-256color XLIB_SKIP_ARGB_VISUALS=1 emacs -nw'
# For sublime, -n is 'new window', -w is 'wait until closed'
export EDITOR='subl -nw'


# no reason why I would use simple cd
function cd() {
    pushd > /dev/null "$*"
}


function mkcd() {
    @mkcd "$@"
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


# creates a IElixir project
function @ielixir-init() {
    cp ~/.betafcc/misc/docker/ielixir.yml ./docker-compose.yml
    docker-compose up
}


# runs elm-reactor with refresh on save
function @selenium-elm() {
    (elm-reactor & @selenium-watch "${1:-src}" "${2:-http://localhost:8000}")
}


function @selenium-watch() {
    (@watch 'echo refresh' "$1" | @selenium-stdin "$2")
}


function @toggle() {
    if [ $(ps cax | grep "$1" | wc -l) -gt 0 ]
    then
        killall "$1"
    else
        $1 "${@:2}"
    fi
}
