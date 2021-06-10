# typeset -A keys=(
#   'right' '^[[C'
#   'up' '^[[A'
#   'left' '^[[D'
#   'down' '^[[B'

#   'M-right' '^[[1;3C'
#   'M-up' '^[[1;3A'
#   'M-left' '^[[1;3D'
#   'M-down' '^[[1;3B'
# )

_,descend() {
  eval $(,goto-folder --descend)
  zle reset-prompt
}

zle -N _,descend
bindkey '^[[1;9B' _,descend

_,ascend() {
  cd ..
  zle reset-prompt
}

zle -N _,ascend
bindkey '^[[1;9A' _,ascend

_,fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null
  selected=(
    $(
      fc -rln 1 |
        perl -ne 'print if !$seen{$_}++' |
        FZF_DEFAULT_OPTS="\
        --height ${FZF_TMUX_HEIGHT:-40%} \
        $FZF_DEFAULT_OPTS \
        -n2..,.. \
        --tiebreak=index \
        --bind=ctrl-r:toggle-sort  \
        --bind=tab:replace-query+top \
        --no-multi \
        --layout=reverse" $(__fzfcmd)
    )
  )
  local ret=$?
  if [ -n "$selected" ]; then
    LBUFFER="${LBUFFER}${selected}"
  fi
  zle reset-prompt
  return $ret
}

zle -N _,fzf-history-widget
bindkey '^R' _,fzf-history-widget

bindkey '^[[z' undo
bindkey '^[[Z' redo

_,location-back() {
  location back
  zle reset-prompt
}

zle -N _,location-back
bindkey '^[[1;9D' _,location-back

_,location-forward() {
  location forward
  zle reset-prompt
}

zle -N _,location-forward
bindkey '^[[1;9C' _,location-forward
