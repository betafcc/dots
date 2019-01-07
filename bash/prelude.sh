__BASHRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"


prelude::is_interactive() {
    [[ $- == *i* ]]
}


prelude::path::source() {
    local _dir="$( cd "$( dirname "${BASH_SOURCE[-1]}" )" >/dev/null && pwd )"
    local _full="${_dir}/"$(basename "${BASH_SOURCE[-1]}")""

    if [ $# -eq 0 ]; then
        echo "${_full}"
    else
        prelude::path::parse "${1}" "${_full}"
    fi
}


prelude::path::parse() {
    case "${1}" in
        dir) dirname "${2}";;
        base) basename "${2}";;
        ext) echo "${2##*.}";;
        name)
            local _base="$(prelude::path::parse base "${2}")"
            echo "${_base%.*}"
            ;;
        help)
            echo "Usage: ${FUNCNAME[0]} <command> <path>"
            echo "    Returns significant parts of <path>"
            echo
            echo "<command> is one of:"
            echo "    dir, base, name, ext"
            echo
            echo "example:"
            echo "    ┌────────────────┬────────────┐"
            echo "    │      dir       │    base    │"
            echo "    │                ├──────┬─────┤"
            echo "    │                │ name │ ext │"
            echo "    ' /home/user/dir / file  .txt '"
            echo "    └────────────────┴──────┴─────┘"
            ;;
        *)
            if prelude::is_interactive; then
                (>&2
                 echo "'${FUNCNAME[0]} ${1}' invalid"
                 prelude::path::parse help
                )
            fi
            return 127;;
    esac
}
