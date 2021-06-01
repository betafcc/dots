_,descend() {
  eval $(,goto-folder --descend)
  zle reset-prompt
}

zle -N _,descend
bindkey '^[[1;9C' _,descend

_,ascend() {
  cd ..
  zle reset-prompt
}

zle -N _,ascend
bindkey '^[[1;9D' _,ascend

fzf-history-widget() {
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

zle -N fzf-history-widget
bindkey '^R' fzf-history-widget
