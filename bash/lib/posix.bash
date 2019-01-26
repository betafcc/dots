quote() {
    local quoted=${1//\'/\'\\\'\'};
    printf "'%s'" "$quoted"
}

# transforms an bash associative array into a posix function
as_function() {
  local key
  local -n arr="${1}"

  printf '%s () {\n' "${1}"
  printf '  case "${1}" in\n'
  for key in "${!arr[@]}"; do
    printf '    %s) printf %s;;\n' \
           "$(quote "${key}")" \
           "$(quote "${arr[${key}]}")"
  done
  printf '    *) echo key "'\''${1}'\''" not in '\''%s'\'' 1>&2; exit 1;;\n' "${1}"
  printf '  esac\n'
  printf '}\n'
}
