# opens a temporary file then pipes the content when closed
@edit() {
    local tempfile=$(mktemp --suffix "$*")
    $EDITOR $tempfile 2>/dev/null
    cat $tempfile
}


# keep redoing $action after waiting $delay
@monitor() {
    local delay="$1"
    local action="${@:2}"
    while true
    do
        eval "$action"
        sleep "$delay"
    done
}


# executes $command after every change in $files
@watch() {
    local command="$1"
    local files="${@:2}"
    while true
    do
        eval "$command"
        inotifywait -qqe close_write $files
    done
}


# creates a IElixir project
@ielixir-init() {
    cp ~/.betafcc/misc/docker/ielixir.yml ./docker-compose.yml
    docker-compose up
}


# just open the jupyter lab url in chrome app mode
@lab() {
    @web-app "http://localhost:${1:-8888}/lab"
}


# runs elm-reactor with refresh on save
@selenium-elm() {
    (elm-reactor & @selenium-watch "${1:-src}" "${2:-http://localhost:8000}")
}


@selenium-watch() {
    (@watch 'echo refresh' "$1" | @selenium-stdin "$2")
}


# utility to open android emulator
@avd() {
    local emulator
    select emulator in $(emulator -list-avds)
    do
        echo "$emulator"
        break
    done
    pushd "${ANDROID_HOME}/tools" >/dev/null
    setsid emulator -avd $emulator
    popd >/dev/null
}


# creates image and run container from pwd dockerfile,
# removing both the container and image afterwards
@docker-here() {
    local img="$(docker build -q .)"
    local args="$@" "$img" "$CMD"
    docker run --rm "$args"
    docker rmi "$img"
}


# works in bash and sh
# TODO: if $0 is zsh, use zsh -c ". $activate; zsh -i" as workaround
# note that this doesnt play nice with pyenv
# as the command is run before the .rc files are loaded in zsh -i
# poetry_shell() {
#     activate="$(dirname $(poetry run which python))/activate"
#     $0 -i <<EOF
# . '${activate}'; exec </dev/tty
# EOF
# }
# FIXME: doesnt work well with ipython, probably because of /dev/tty
