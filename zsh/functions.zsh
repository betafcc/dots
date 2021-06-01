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
