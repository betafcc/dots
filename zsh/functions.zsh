,mkcd() {
  mkdir -p "${1}"
  cd "${1}"
}

alias mkcd=',mkcd'

,jupyter() {
  # pipenv run jupyter lab \
  #   --browser='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --app="%s"'
  pipenv run jupyter lab \
    --browser=',browser %s'
}

,history() {
  fc -i -l 1
}

,past-commit() {
  local timezone=$(date +"%z")
  GIT_COMMITTER_DATE="${1} ${timezone}" \
    GIT_AUTHOR_DATE="${1} ${timezone}" \
    git commit -m "${2}"
}

,moteef() {
  local moteef="${HOME}/Desktop/moteefe/moteef"
  cd "${moteef}"

  case "${1}" in
  db) docker-compose up db redis elasticsearch ;;
  web) docker-compose up web jobs ;;
  migrate) docker-compose run web rails db:migrate ;;
  client) cd client && yarn start ;;
  nextjs) cd nextjs-client && yarn run dev ;;
  libs) cd ../frontend-libs && yarn start ;;
  esac
}

,watch() {
  while true; do
    clear
    printf '=%.0s' $(seq $(tput cols))
    eval "${2}"
    fswatch -1 "${1}"
  done
}

,coverage() {
  yarn jest --coverage &&
    git diff origin/master...HEAD |
    diff-test-coverage -c coverage/lcov.info -t lcov -l 80 -b 80 -f 80
}

,extract() {
  if [ -f $1 ]; then
    case $1 in
    *.tar.bz2) tar xvjf $1 ;;
    *.tar.gz) tar xvzf $1 ;;
    *.bz2) bunzip2 $1 ;;
    *.rar) rar x $1 ;;
    *.gz) gunzip $1 ;;
    *.tar) tar xvf $1 ;;
    *.tbz2) tar xvjf $1 ;;
    *.tgz) tar xvzf $1 ;;
    *.zip) unzip $1 ;;
    *.Z) uncompress $1 ;;
    *.7z) 7z x $1 ;;
    *) echo "don't know how to extract '$1'..." ;;
    esac
  else
    echo "'$1' is not a valid file!"
  fi
}

,rg() {
  local INITIAL_QUERY="${1:-}"
  local RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
  FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" \
    fzf \
    --bind \
    "change:reload:$RG_PREFIX {q} || true" \
    --ansi \
    --disabled \
    --query "$INITIAL_QUERY" \
    --layout=reverse \
    --delimiter : \
    --bind 'alt-e:execute(e +{2}:{3} {1})' \
    --bind 'alt-o:execute(code {1})' \
    --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
    --preview-window +{2}-/2
}
