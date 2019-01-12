bind '"\C-x\C-f": " \C-e\C-u$(🙇)\e\C-e\er\C-m"'

# C-left
bind '"\e[1;5D": " \C-a\C-k`echo cd ..`\e\C-e\er\C-m\C-y\C-b\C-d"'

bind '"\e[1;5C": "\C-e \C-u`C-right`\e\C-e\er\C-m\C-y\C-b\C-d"'


bind '"\C-x\C-d": "\C-e \C-u`C-x,C-d`\e\C-e\er\C-m\C-y\C-b\C-d"'


C-right() (
    choose_directory_macro
)


C-x,C-d() (
    cd "${HOME}"
    printf 'cd %q;' "$(pwd)"
    choose_directory_macro
)


choose_directory() {
    fd \
        --type d \
        --hidden \
        --no-ignore \
        --exclude '.git' \
        --exclude 'node_modules' \
        | sed 's_$_/_' \
        | fzf \
              --color 'dark' \
              --height 80% \
              --layout reverse \
              --no-multi \
              --preview 'exa --color=always --icons {}' \
              --preview-window 'right:40%' \
              --filepath-word \
              --bind 'tab:replace-query+top,shift-tab:backward-kill-word+top' \
              "$@"
}


choose_directory_macro() {
    choose_directory --expect='alt-m,alt-e' | (
        set --
        while read -r; do
            set -- "$@" "${REPLY}"
        done
        _choose_directory_macro "$@"
    )
}


_choose_directory_macro() {
    case "${1}" in
        'alt-m') printf 'setsid xdg-open %q </dev/null >/dev/null 2>&1' "${2}";;
        'alt-e') printf 'pushd %q >/dev/null; "${EDITOR}" .' "${2}";;
        *) printf 'pushd %q >/dev/null' "${2}";;
    esac
}
