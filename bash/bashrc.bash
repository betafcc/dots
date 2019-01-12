# shellcheck disable=SC1090
source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )/prelude.sh"


::import './lib/dev_utils.sh' as ::dev_utils
# TODO: actually factor out a decent emacs wrapper
::import './lib/emacs.sh'     as ::emacs     exposing \
         emacs \
         xemacs \
         emax \
         xemax \
         rgx
::import './lib/loggers.sh'   as ::loggers
::import './lib/misc.sh'      as ::misc      exposing \
         grepless \
         rgless
::import './lib/os_utils.sh'  as ::os_utils  exposing ..
::import './lib/slicing.sh'   as ::slicing   exposing \
         take \
         drop \
         every
::import './modes.sh' as ::modes exposing ..
::import './keybindings.bash' as ::keybindings exposing ..


+prompt powerline

shopt -s autocd

# until we fix `poetry shell`
alias poetry_shell='. "$(dirname $(poetry run which python))/activate"'

# default dir lister
_l() { exa --color=always --icons "$@" | less -RXF; }
alias l='_l'
alias la='_l -a'


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

alias r='ranger'

# TODO: maybe check if running in kitty?
alias icat="kitty +kitten icat"

export EDITOR="e"
