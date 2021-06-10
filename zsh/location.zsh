location() {
  case "${1:-select}" in
  select)
    printf '%q\n' "${_location_history[@]}"
    ;;

  activate)
    typeset -g -a _location_history=()
    typeset -g _location_index=0
    typeset -g _location_push=true

    chpwd() {
      if [ $_location_push = true ]; then
        location push "$(pwd)"
      else
        _location_push=true
      fi
    }

    location push "$(pwd)"
    ;;

  push)
    if [ "$2" != "${_location_history[-1]}" ]; then
      _location_history=(${_location_history[@]:0:$_location_index})
      _location_history+=($2)
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
