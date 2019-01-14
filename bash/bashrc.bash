# shellcheck disable=SC1090
source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )/prelude.sh"


filez() ( # () -> string
    set -- "$(fd --hidden --no-ignore --exclude '.git' --exclude '.cache' | fzf --reverse --height=60% --multi --exit-0 --expect=ctrl-o,alt-e,ctrl-m,ctrl-x,ctrl-c)"
    # POSIX string splitting into arg array
    old_IFS="${IFS}" IFS=$'\n'; set -- $@; IFS="${old_IFS}"

    case "${1}" in
        # open
        'ctrl-o') shift; printf '%q ' 'xdg-open' "$@";;
        # edit
        'alt-e') shift; printf '%q ' 'emacs' "$@";;
        # execute
        'ctrl-x') shift; printf './%q' "${1}"; shift; printf ' %q' "$@";;
        # cd into
        'ctrl-m')
            shift; if [ -d "${1}" ]; then
                       printf 'pushd %q >/dev/null' "${1}"
                   else
                       printf 'pushd "$(dirname %q)" >/dev/null' "${1}"
                   fi
            ;;
        # output
        # 'ctrl-m') shift; printf '%q ' "$@";;
    esac
)

🙇() {
    filez "$@"
}


_dirs() {  # TODO: auto select on only one
    local old_IFS arg
    set -- "$(fd . --maxdepth=1 --hidden --type=d | fzf --reverse --height=60% --exit-0 --select-1 --expect=tab,shift-tab,ctrl-m)"

    old_IFS="${IFS}" IFS=$'\n'; set -- $@; IFS="${old_IFS}"

    case "${1}" in
        'tab') shift; cd "${1}"; _dirs;;
        'shift-tab') shift; cd ..; _dirs;;
        'ctrl-m')
            shift
            printf 'pushd "%q" >/dev/null' "${1}"
            ;;
    esac
}
