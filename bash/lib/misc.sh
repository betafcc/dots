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


# grep + less
@grepless() {
    grep --color=always "$@" | less -R
}


# ripgrep + less
@rgless() {
    rg --color=always "$@" | less -R
}


@resolve_alias() {
    local alias_
    for alias_ in "$@"
    do
        echo "${BASH_ALIASES[$alias_]}"
    done
}
