# no reason why I would use simple cd
pd() {
    pushd > /dev/null "$@"
}


# creates a directory and enters it
mkcd() {
    mkdir -p "$@" && pd "$@"
}


# creates parent directory before touching file
touchp() (
    for file_path in "$@"; do
        file_dir=$(dirname "${file_path}")
        mkdir -p "${file_dir}"
        touch "${file_path}"
    done
)


toggle() {
    if [ $(ps cax | grep "${1}" | wc -l) -gt 0 ]; then
        killall "${1}"
    else
        $1 "${@:2}"
    fi
}
