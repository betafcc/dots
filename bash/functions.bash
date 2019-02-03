,ls() {
  exa \
    --color=always \
    --icons \
    --group-directories-first \
    "$@" \
    | less -RXF
}


,mkcd() {
  mkdir -p "${1}"
  cd "${1}"
}
