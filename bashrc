# -nw for emacs means 'no-window'
alias emacs='TERM=xterm-256color XLIB_SKIP_ARGB_VISUALS=1 emacs -nw'
# For sublime, -n is 'new window', -w is 'wait until closed'
export EDITOR='subl -nw'


# no reason why I would use simple cd
cd() {
    pushd > /dev/null "$*"
}


mkcd() {
    @mkcd "$@"
}


# creates a directory and enters it
@mkcd() {
    mkdir -p "$@" && cd "$@"
}


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


# open url in chrome app mode
@web-app() {
    google-chrome --app="${1}"
}


# searches on youtube
@youtube() {
    local query=$(echo "$@" | tr ' ' '+')
    @web-app "https://www.youtube.com/results?search_query=${query}"
}


# searches on google
@google() {
    local query=$(echo "$@" | tr ' ' '+')
    google-chrome --new-window "https://www.google.com.br/search?q=${query}"

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


@toggle() {
    if [ $(ps cax | grep "$1" | wc -l) -gt 0 ]
    then
        killall "$1"
    else
        $1 "${@:2}"
    fi
}


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


@window-logger() {
    local delay="${1:-2}" # default delay is 2 seconds

    @monitor $delay 'xdotool getactivewindow getwindowname' |
        stdbuf -oL uniq |
        while read line
        do
            echo "$(date +'%Y-%m-%d %H:%M:%S%z') > ${line}"
        done
}


@screen-logger() {
    local basedir="${1}"
    local delay="${2-10}"
    local outdir
    while true
    do
        sleep ${delay}
        outdir="${basedir}/$(date -I)"
        mkdir -p "${outdir}"
        import \
            -resize 50% \
            -interlace Plane \
            -quality 55% \
            -window root \
            -silent \
            "${outdir}/$(date -Iseconds).jpg"
    done
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

alias poetry_shell='. "$(dirname $(poetry run which python))/activate"'

# creates image and run container from pwd dockerfile,
# removing both the container and image afterwards
@docker-here() {
    local img="$(docker build -q .)"
    local args="$@" "$img" "$CMD"
    docker run --rm "$args"
    docker rmi "$img"
}


take() {
    if [ $1 -lt 0 ]
    then
        @take-last $(expr '-1' '*' $1)
    else
        @take-first $1
    fi
}

@take-first() {
    head -$1
}


@take-last() {
    tail -$1
}


drop() {
    if [ $1 -lt 0 ]
    then
        @drop-last $(expr '-1' '*' $1)
    else
        @drop-first $1
    fi
}


@drop-first() {
    tail -n +$(expr $1 + 1)
}


@drop-last() {
    head -n -$1
}


every() {
    if [ $1 -lt 0 ]
    then
        tac | every $(expr '-1' '*' $1)
    else
        sed -n "1~${1}p"
    fi
}
