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
