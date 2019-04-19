,ls() {
  colorls \
    --color=always \
    --group-directories-first \
    --light \
    "$@" \
    | less -RXF
}


,mkcd() {
  mkdir -p "${1}"
  cd "${1}"
}


,completions() {
  local columns flag name spaces
  local -A colors=(
    [a]='\e[1;33m' # 'bold+yellow'
    [b]='\e[1;32m' # 'bold+green'
    [c]='\e[1m' # 'bold'
    [d]='\e[34m' # 'blue'
    [e]='\e[4;34m' # 'underline+blue'
    [f]='\e[1;31m' # 'bold+red'
    [g]='\e[1m' # 'bold'
    [j]='\e[33m' # 'yellow'
    [k]='\e[1;32m' # 'bold+green'
    [s]='\e[1m' # 'bold'
    [u]='\e[1m' # 'bold'
    [v]='\e[34m' # 'blue'
  )
  local -A names=(
    [a]='alias'
    [b]='builtin'
    [c]='command'
    [d]='directory'
    [e]='exported var'
    [f]='file or function'
    [g]='group'
    [j]='job'
    [k]='reserved'
    [s]='service'
    [u]='user alias'
    [v]='variable'
  )

  columns="$(tput cols)"
  if ((columns > 60)); then
    columns=60
  fi

  for flag in "${!names[@]}"; do
    compgen -"${flag}" | while IFS= read -r line; do
      name="${names[${flag}]}"

      spaces=$((${columns} - ${#name} - ${#line} - 3))
      if ((spaces < 1)); then
        spaces=1
      fi

      printf '%b%s\e[0m%*s\e[1m(%s)\e[0m\n' \
             "${colors[${flag}]}" \
             "${line}" \
             "${spaces}" \
             '' \
             "${name}"
    done
  done
}


,meta-x() {
  ,completions \
    | fzf \
        --ansi \
        --color light \
        --layout reverse \
        --height 80% \
        --no-multi \
    | sed -e 's/[[:space:]]\+\(.\+\)//'
}
