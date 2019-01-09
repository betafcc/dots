# opens a temporary file then pipes the content when closed
edit() (
    tempfile=$(mktemp --suffix "$@")
    $EDITOR $tempfile 2>/dev/null
    cat $tempfile
)


# keep redoing $action after waiting $delay
repeat() (
    delay="$1"
    action="${@:2}"
    while true; do
        eval "${action}"
        sleep "${delay}"
    done
)


# executes $command after every change in $files
watch() {
    command="${1}"
    files="${@:2}"
    while true; do
        eval "${command}"
        inotifywait -qqe close_write "${files}"
    done
}


# creates a IElixir project
ielixir_init() {
    cp ~/.betafcc/misc/docker/ielixir.yml ./docker-compose.yml
    docker-compose up
}


# just open the jupyter lab url in chrome app mode
lab() {
    web_app "http://localhost:${1:-8888}/lab"
}


# runs elm-reactor with refresh on save
selenium_elm() {
    (elm-reactor & selenium_watch "${1:-src}" "${2:-http://localhost:8000}")
}


selenium_watch() {
    (watch 'echo refresh' "${1}" | selenium-stdin "${2}")
}


# utility to open android emulator
avd() (
    select emulator in $(emulator -list-avds); do
        echo Opening "'${emulator}'"
        break
    done
    cd "${ANDROID_HOME}/tools"
    setsid emulator -avd "${emulator}"
)


# creates image and run container from pwd dockerfile,
# removing both the container and image afterwards
# TODO: actually handle the CMD optional argument
# it needs to be at the end while the rest of the arguments
# need to be before image, maybe add --cmd flag
# As of now you call it like: `CMD=bash docker_here -v foo:bar`
docker_here() (
    img="$(docker build -q .)"
    docker run --rm "$@" "${img}" "${CMD}"
    docker rmi "${img}"
)


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
