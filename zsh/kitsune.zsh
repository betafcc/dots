# https://unix.stackexchange.com/questions/157693/howto-include-output-of-a-script-into-the-zsh-prompt
# http://zsh.sourceforge.net/Doc/Release/Parameters.html
# https://books.google.pl/books?id=_q7ZgTUvft0C&pg=PA156&lpg=PA156&dq=psvar+escape+characters&source=bl&ots=IkvTl68QZh&sig=ACfU3U09u82ndrLmaW9oM6wBKCrHE4OoXw&hl=en&sa=X&ved=2ahUKEwighN7Wos_wAhUllIsKHeReBRAQ6AEwD3oECAYQAw#v=onepage&q=psvar%20escape%20characters&f=false
# http://bolyai.cs.elte.hu/zsh-manual/zsh_15.html
# https://stackoverflow.com/questions/36192523/zsh-prompt-customization
# https://unix.stackexchange.com/questions/153102/how-to-start-xterm-with-prompt-at-the-bottom

KITSUNE_PATH="$0:A"

_kitsune-compile() {
  _ks_template[prompt.PS1]=$(
    for name in tag path arrow; do
      printf '${(e)_ks_template[%s.${_ks_model[%s.key]}]}' "${name}" "${name}"
    done
  )
  _ks_template[prompt.RPROMPT]=$(
    for name in venv git; do
      printf '${(e)_ks_template[%s.${_ks_model[%s.key]}]}' "${name}" "${name}"
    done
  )
  _ks_template[prompt.PS2]='▐ '
  _ks_template[prompt.PS4]='▐ <bold+#2aa198:${FUNCNAME[0]}<#b58900::${LINENO}:>> '

  _ks_template[tag.${HOME}/Desktop]='<bold:【<#2aa198:今>】>'
  _ks_template[tag.${HOME}]='<bold:【<#b58900:家>】>'
  _ks_template[tag.${HOME}/.Trash]='<bold:【<#6339b3:圾>】>'
  _ks_template[tag./]='<bold:【<red:本>】>'

  _ks_template[path.no_untagged]=''
  _ks_template[path.single_untagged]='<bold:${_ks_model[sys.W]} >'
  _ks_template[path.multi_untagged]='<bold:<#aaa:$(printf "❯%%.0s" $(seq $((${_ks_model[tag.untagged_levels]} - 1))))> ${_ks_model[sys.W]} >'

  _ks_template[arrow.erroed_last]='<bold+#dc322f:❱ >'
  _ks_template[arrow.has_jobs]='<bold+#b58900:❱ >'
  _ks_template[arrow.ok]='<bold+#2aa198:❱ >'

  if [ "$KITSUNE_VENV_VERBOSE" = "true" ]; then
    _ks_template[venv.on]='<bold+#2aa198:[<#b58900:> <white:${_ks_model[venv.name]}>]>'
    _ks_template[venv.off]=''
  else
    _ks_template[venv.on]='<bold+#2aa198:[<#b58900:>]>'
    _ks_template[venv.off]=''
  fi

  if [ "$KITSUNE_GIT_VERBOSE" = "true" ]; then
    _ks_template[git.modified]='<bold:[<red: ${_ks_model[git.branch]}>]>'
    _ks_template[git.staged]='<bold:[<red: ${_ks_model[git.branch]}>]>'
    _ks_template[git.untracked]='<bold:[<red: ${_ks_model[git.branch]}>]>'
    _ks_template[git.behind_ahead]='<bold:[<#b58900: ${_ks_model[git.branch]}>]>'
    _ks_template[git.ok]='<bold:[<#2aa198: ${_ks_model[git.branch]}>]>'
    _ks_template[git.not_repo]=''
  else
    _ks_template[git.modified]='<bold:[<red:>]>'
    _ks_template[git.staged]='<bold:[<red:>]>'
    _ks_template[git.untracked]='<bold:[<red:>]>'
    _ks_template[git.behind_ahead]='<bold:[<#b58900:>]>'
    _ks_template[git.ok]='<bold:[<#2aa198:>]>'
    _ks_template[git.not_repo]=''
  fi

  for key in "${(@k)_ks_template}"; do
    _ks_template[${key}]=$(clc --escape zsh "${_ks_template[${key}]}")
  done
}

typeset -A _ks_model=(
  [venv.key]='off'
  [venv.name]=''

  [sys.q]=''
  [sys.j]=''
  [sys.W]='%1d'

  [tag.key]='/'
  [tag.untagged_levels]=0
  [path.key]=no_untagged

  [git.key]=not_repo
  [git.branch]=''

  [arrow.key]=ok
)

_kitsune-render() {
  _kitsune-update "${1}"
  printf %b "${(e)_ks_template[prompt.${(U)1:-ps1}]}"
}


_kitsune-update() {
  case "${1:-all}" in
    ps1)
      # sys need to be first, otherwise, return code won't be right
      _kitsune-update sys
      _kitsune-update tag
      _kitsune-update path
      _kitsune-update arrow
      ;;

    rprompt)
      _kitsune-update git
      _kitsune-update venv
      ;;

    venv)
      if [ -n "$VIRTUAL_ENV" ]; then
        _ks_model[venv.key]=on
        _ks_model[venv.name]="${${VIRTUAL_ENV%-**}##*/}"
      else
        _ks_model[venv.key]=off
      fi
      ;;

    sys)
      _ks_model[sys.q]=$?
      _ks_model[sys.j]=$( (jobs) | wc -l | xargs )
      ;;

    tag)
      local dir="${PWD}"
      local untagged_levels=0

      until [ ${_ks_template[tag.${dir}]+x} ] || [ -z "${dir}" ]; do
        ((++untagged_levels))
        dir="${dir%/*}"
      done

      _ks_model[tag.key]="${dir:-/}"
      _ks_model[tag.untagged_levels]="${untagged_levels}"
      ;;

    path)
      case "${_ks_model[tag.untagged_levels]}" in
        0) _ks_model[path.key]=no_untagged;;
        1) _ks_model[path.key]=single_untagged;;
        *) _ks_model[path.key]=multi_untagged;;
      esac
      ;;

    git)
      _ks_model[git.branch]=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)

      if [ -n "${_ks_model[git.branch]}" ]; then
        if [ ! "$(git diff --name-only --diff-filter=M 2> /dev/null | wc -l )" -eq "0" ]; then
          _ks_model[git.key]=modified
        elif [ ! "$(git diff --staged --name-only --diff-filter=AM 2> /dev/null | wc -l)" -eq "0" ]; then
          _ks_model[git.key]=staged
        elif [ ! "$(git ls-files --other --exclude-standard | wc -l)"  -eq "0" ]; then
          _ks_model[git.key]=untracked
        else
          local number_behind_ahead
          number_behind_ahead="$(git rev-list --count --left-right '@{upstream}...HEAD' 2>/dev/null)"
          if [ ! "0${number_behind_ahead#*	}" -eq 0 -o ! "0${number_behind_ahead%	*}" -eq 0 ]; then
            _ks_model[git.key]=behind_ahead
          else
            _ks_model[git.key]=ok
          fi
        fi
      else
        _ks_model[git.key]=not_repo
      fi
      ;;

    arrow)
      case "${_ks_model[sys.q]},${_ks_model[sys.j]}" in
        0,0) _ks_model[arrow.key]=ok;;
        0,*) _ks_model[arrow.key]=has_jobs;;
        *,*) _ks_model[arrow.key]=erroed_last;;
      esac
      ;;
  esac
}


_kitsune-bind-shell() {
  setopt prompt_subst

  preexec() {}
  precmd() {}

  PROMPT='$(_kitsune-render ps1)'
  PS2='$(_kitsune-render ps2)'
  RPROMPT='$(_kitsune-render rprompt)'

  if [ "${KITSUNE_LOCK}" = "top" ]; then
    PROMPT=$'%{\e[H%}'"${PROMPT}"
    preexec() {
      clear
      tput cup 1 0
    }
  elif [ "${KITSUNE_LOCK}" = "bottom" ]; then
    preexec() {
      clear
      tput cup $(tput lines) 0
    }
  else
    preexec() {}
    precmd() {}
  fi

  # for venv module, don't mess with PS1 on venv activation
  VIRTUAL_ENV_DISABLE_PROMPT=true

  # chpwd() {
  #   if [ -f "${PWD}/Pipfile" ]; then
  #     source "$(pipenv --venv 2>/dev/null)/bin/activate"
  #   fi
  # }
}

_not() {
  if [ "${1:-false}" = "false" ]; then
    echo -n true
  else
    echo -n false
  fi
}

kitsune() {
  case "${1:-activate}" in
    activate)
      if [ ! -f "${HOME}/.kitsunedump" ]; then
        (
          typeset -g -A _ks_template=()
          _kitsune-compile
          declare -p _ks_template > "${HOME}/.kitsunedump"
        )
      fi

      source "${HOME}/.kitsunedump"
      _kitsune-bind-shell
    ;;
    reload)
      _kitsune-compile
      declare -p _ks_template > "${HOME}/.kitsunedump"
      _kitsune-bind-shell
    ;;
    lock)
      export KITSUNE_LOCK="${2:-bottom}"
      kitsune reload
    ;;
    git)
      case "${2:-none}" in
        verbose)
          export KITSUNE_GIT_VERBOSE=$(_not $KITSUNE_GIT_VERBOSE)
          kitsune reload
        ;;
      esac
    ;;
    venv)
      case "${2:-none}" in
        verbose)
          export KITSUNE_VENV_VERBOSE=$(_not $KITSUNE_VENV_VERBOSE)
          kitsune reload
        ;;
      esac
    ;;
    theme)
      case "${2:-dark}" in
        dark) export BAT_THEME=gruvbox;;
        light) export BAT_THEME=OneHalfLight;;
      esac
  esac
}
