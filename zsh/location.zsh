# LOCATION_HISTORY_FILE="${HOME}/.betafcc/zsh/.location_history"
# location history
# location history list
# location history activate
# location history push "./foo"
# location history back
# location history forward

# LOCATION_TAG_FILE="${HOME}/.betafcc/zsh/.location_tag"
# location tag
# location tag list
# location tag add $(clc '<red:【犬】>') .
# location tag remove .

location() {
  local command="${1:-help}"
  [ $# -gt 0 ] && shift

  case "${command}" in
  history) _location-history "${@}" ;;
  tag) _location-tag "${@}" ;;
  *) echo "usage: location [history|tag]" ;;
  esac
}

_location-history() {
  local command="${1:-select}"
  [ $# -gt 0 ] && shift

  case "${command}" in
  select)
    local dir
    local i=1
    for dir in "${_location_history[@]}"; do
      if [ $i -eq $_location_index ]; then
        clc "<bold+green:${dir}>\n"
      else
        printf '%q\n' "${dir}"
      fi
      i=$((i + 1))
    done
    ;;

  activate)
    typeset -g -a _location_history=()
    typeset -g _location_index=0
    typeset -g _location_push=true

    chpwd() {
      if [ $_location_push = true ]; then
        location history push "$(pwd)"
      else
        _location_push=true
      fi
    }

    location history push "$(pwd)"
    ;;

  push)
    local path="${1}"
    [ $# -gt 0 ] && shift

    if [ "${path}" != "${_location_history[-1]}" ]; then
      _location_history=(${_location_history[@]:0:$_location_index})
      _location_history+=(${path})
      _location_index=$((${#_location_history[@]}))
    fi
    ;;

  back)
    [[ $_location_index -gt 1 ]] &&
      _location_index=$((_location_index - 1))
    _location_push=false
    cd "${_location_history[$_location_index]}"
    ;;

  forward)
    [[ $_location_index -lt ${#_location_history[@]} ]] &&
      _location_index=$((_location_index + 1))
    _location_push=false
    cd "${_location_history[$_location_index]}"
    ;;
  esac
}

_location-tag() {
  local command="${1:-select}"
  [ $# -gt 0 ] && shift
}
