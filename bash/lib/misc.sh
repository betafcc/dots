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
    grep --color=always "$@" | less -R -X
}


# ripgrep + less
@rgless() {
    rg --color=always "$@" | less -R -X
}


@resolve_alias() {
    local alias_
    for alias_ in "$@"
    do
        echo "${BASH_ALIASES[$alias_]}"
    done
}

@show_colors() {
    awk 'BEGIN{
        s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
        for (colnum = 0; colnum<77; colnum++) {
            r = 255-(colnum*255/76);
            g = (colnum*510/76);
            b = (colnum*255/76);
            if (g>255) g = 510-g;
            printf "\033[48;2;%d;%d;%dm", r,g,b;
            printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
            printf "%s\033[0m", substr(s,colnum+1,1);
        }
        printf "\n";
    }'
}
