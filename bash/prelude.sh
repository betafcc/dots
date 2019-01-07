__BASHRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
__PRELUDE_SRC="${__BASHRC_DIR}/"$(basename "${BASH_SOURCE[0]}")""



prelude::import() {
    local reference
    local name
    local resolved_reference

    if [[ ! -n "${1}" || "${1}" = "help"  ]]; then
      echo  "Usage:
    prelude::import <library_reference> [as <name>] [exposing ['..'| ...functions]]

Examples:
    prelude::import './foo/bar.sh'
        imports from relative path as 'bar'

    prelude::import './foo/bar.sh' as mod
        imports from relative path as 'mod'

    prelude::import './foo/bar.sh' exposing f g h
        imports from relative path setting alias for f g and h

    prelude::import './foo/bar.sh' exposing ..
        imports from relative path and also sources it"

      return 1
    fi

    reference="${1}"
    shift

    case "${1}" in
        as)
            shift
            if [ -n "${1}" ]; then
                name="${1}"
            else
                return 1
            fi
            shift
        ;;

        "" | exposing)
            name="$(prelude::path::parse name "${reference}")"
            ;;

        *)
            return 1
            ;;
    esac


    # resolve reference last, cause it's the heaviest operation
    if [[ "${reference:0:1}" = "/" ]]; then
        resolved_reference="${reference}"
    elif [[ "${reference:0:1}" = "." ]]; then
        if prelude::process::is_shell; then
            resolved_reference="$(pwd)/${reference}"
        else
            resolved_reference="$(prelude::path::source dir)/${reference}"
        fi
    else
        return 1
    fi

    eval "
        ${name}() (
            source "${resolved_reference}"
            "'"$@"'"
        )
    "

    if [ "${1}" = "exposing" ]; then
        shift
        if [[ $# -eq 1 && "${1}" = ".." ]]; then
            source "${resolved_reference}"
        else
            for el in "$@"; do
                eval "${el}() { "${name}" "${el}" "'"$@"'"; }"
            done
        fi
    fi
}


alias +import="prelude::import"


{
    prelude::process::is_interactive() {
        [[ $- == *i* ]]
    }


    prelude::process::is_shell() {
        [ "$(prelude::path::last_source)" = "${__PRELUDE_SRC}" ]
    }
}


{
    prelude::path::is_absolute() {
        [ "${1:0:1}" = "/" ]
    }


    prelude::path::last_source() {
        local _dir="$( cd "$( dirname "${BASH_SOURCE[-1]}" )" >/dev/null && pwd )"
        local _full="${_dir}/"$(basename "${BASH_SOURCE[-1]}")""
        echo "${_full}"
    }


    prelude::path::source() {
        if prelude::process::is_shell; then
            (>&2 echo "Can't get source file path from shell")
            return 1
        fi

        local _full="$(prelude::path::last_source)"

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
                if prelude::process::is_interactive; then
                    (>&2
                     echo "'${FUNCNAME[0]} ${1}' invalid"
                     prelude::path::parse help
                    )
                fi
                return 127;;
        esac
    }
}
