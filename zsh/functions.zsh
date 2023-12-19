,mkcd() {
  mkdir -p "${1}"
  cd "${1}"
}

alias mkcd=',mkcd'

,jupyter() {
  # pipenv run jupyter lab \
  #   --browser='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --app="%s"'
  pipenv run jupyter lab \
    --browser=',browser %s' \
    "$@"
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

# ,moteef() {
#   local moteef="${HOME}/Desktop/moteefe/moteef"
#   cd "${moteef}"

#   case "${1}" in
#   db) docker-compose up db redis elasticsearch ;;
#   web) docker-compose up web jobs ;;
#   migrate) docker-compose run web rails db:migrate ;;
#   client) cd client && yarn start ;;
#   nextjs) cd nextjs-client && yarn run dev ;;
#   libs) cd ../frontend-libs && yarn start ;;
#   esac
# }

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

,source-export() {
  local file
  # https://stackoverflow.com/questions/19331497/set-environment-variables-from-file-of-key-value-pairs
  for file in "${@}"; do
    set -a
    . ./"${file}"
    set +a
  done
}

# TODO: not possible to use this in config?
alias ghci='ghci -v0'
# -v0: disable GHCi banner

# ,toggle-inline-edit-mode() {
#   if [[ "${_INLINE_EDIT}" == "true" ]]; then

#     _INLINE_EDIT="true"
#   else
#     _INLINE_EDIT="false"
#   fi
#   fi
# }

# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#log-tailing
,pods() {
  FZF_DEFAULT_COMMAND="kubectl get pods --all-namespaces" \
    fzf --info=inline --layout=reverse --header-lines=1 \
    --prompt "$(kubectl config current-context | sed 's/-context$//')> " \
    --header $'╱ Enter (kubectl exec) ╱ CTRL-O (open log in editor) ╱ CTRL-R (reload) ╱\n\n' \
    --bind 'ctrl-/:change-preview-window(80%,border-bottom|hidden|)' \
    --bind 'enter:execute:kubectl exec -it --namespace {1} {2} -- bash > /dev/tty' \
    --bind 'ctrl-o:execute:${EDITOR:-vim} <(kubectl logs --all-containers --namespace {1} {2}) > /dev/tty' \
    --bind 'ctrl-r:reload:$FZF_DEFAULT_COMMAND' \
    --preview-window up:follow \
    --preview 'kubectl logs --follow --all-containers --tail=10000 --namespace {1} {2}' "$@"
}

# a command to mimic comment in shell and history
\#() {}

# OPENAI_API_KEY_FILE="${HOME}/.openai/api_key"

# ,inline-suggest() {
#   local input=$(
#     tail -100 "${HISTFILE}" | sed -e 's/^[^;]*;\(.*\)/\1/'
#   )
#   local api_key=$(cat "${OPENAI_API_KEY_FILE}")
#   local prompt=$(echo -n "${input}" | jq -Rsa .)

#   # curl -s https://api.openai.com/v1/chat/completions \
#   #   -H 'Content-Type: application/json' \
#   #   -H "Authorization: Bearer ${api_key}" \
#   #   -d '{
#   #     "model": "gpt-3.5-turbo",
#   #     "messages": [{"role": "user", "content": '${prompt}'}],
#   #     "temperature": 0.7,
#   #     "n": 5
#   #   }' |
#   #   jq '.choices[].message.content' | fzf

#   curl https://api.openai.com/v1/completions \
#     -H 'Content-Type: application/json' \
#     -H "Authorization: Bearer ${api_key}" \
#     -d '{
#     "model": "code-davinci-002",
#     "prompt": '"${prompt}"',
#     "temperature": 0,
#     "max_tokens": 256,
#     "top_p": 1,
#     "frequency_penalty": 0,
#     "presence_penalty": 0
#   }' |
#     jq '.choices[].text'
# }

# ,gpt() {
#   local input="${1}" # string
#   local api_key=$(cat "${OPENAI_API_KEY_FILE}")
#   local prompt=$(echo -n "${input}" | jq -Rsa .)

#   curl -s https://api.openai.com/v1/completions \
#     -H 'Content-Type: application/json' \
#     -H "Authorization: Bearer ${api_key}" \
#     -d '{
#     "model": "code-davinci-002",
#     "prompt": '"${prompt}"',
#     "temperature": 0,
#     "max_tokens": 256,
#     "top_p": 1,
#     "frequency_penalty": 0,
#     "presence_penalty": 0,
#     "stop": "\n"
#   }'
# }

,qr-start() {
  cross-env NEXT_TELEMETRY_DEBUG=1 cross-env REACT_APP_API_PROXY_URL=http://localhost:3001 cross-env REACT_APP_FAQ_WP_API_ENDPOINT="https://tst.myqrcode.com/wp-json/myqrcode/v1/faq/" yarn run dev
}
