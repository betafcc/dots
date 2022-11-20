# Use emacs keybindings mode by default
bindkey -A emacs main

# Docs on zle and bindkey: https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html
#
# cheatsheet:
#   `zle -al` to list all zle commands
#   `zle -N widget [function]`
#   `bindkey -L` to list all keybindings
#   `bindkey -l` to list keymaps
#   `bindkey -v` to activate vi mode
#   `bindkey -e` to activate emacs mode
#   `bindkey -M emacs` to list all emacs keybindings
#   `bindkey -M viins` to list all viins keybindings

# Some useful key codes
#
# Note I'm manually setting overrides on terminal emulator app settings to mirror `_keys` intent
# for instance, on iTerm settings (⌘, -> Profiles -> Keys -> Key Mappings) I have:
# eg: Send ^[ [z        ⌘z
# Keyboard Shortcut: ⌘z
# Action: Send Escape Sequence
# Esc+: [z
# TODO: Do the same for vscode terminal overrides?
typeset -A _keys=(
  'right' '^[[C'
  'up' '^[[A'
  'left' '^[[D'
  'down' '^[[B'

  'alt+right' '^[[1;9C'
  'alt+up' '^[[1;9A'
  'alt+left' '^[[1;9D'
  'alt+down' '^[[1;9B'

  'cmd+right' '^[[1;5C'
  'cmd+up' '^[[1;5A'
  'cmd+left' '^[[1;5D'
  'cmd+down' '^[[1;5B'

  'ctrl+r' '^R'
  'cmd+p' '^[[p'
  'cmd+z' '^[[z'
  'cmd+shift+z' '^[[Z'
  'cmd+shift+f' '^[[F'
)

,bindkey() {
  if [ $1 = '-N' ]; then
    eval "_,${2}() { ${3} }"
    zle -N _,${2}
    bindkey "${_keys[${2}]}" "_,${2}"
  else
    bindkey "${_keys[${1}]}" "${2}"
  fi
}

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
        --layout=reverse" fzf
    )
  )
  local ret=$?
  if [ -n "$selected" ]; then
    LBUFFER="${LBUFFER}${selected}"
  fi
  zle reset-prompt
  return $ret
}

# _,descend() {
#   bfs \
#     -x \
#     -type d -readable -o -prune \
#     -exclude -name '.git' \
#     -exclude -name 'node_modules' \
#     2>/dev/null |
#     sed 's:$:/:'
# }

autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# ,bindkey -N cmd+down '_,descend'
,bindkey -N cmd+down 'print -n "\r"; eval $(,goto-folder --descend); zle reset-prompt'
,bindkey -N cmd+up 'cd ..; zle reset-prompt'
,bindkey -N cmd+left 'location history back; zle reset-prompt'
,bindkey -N cmd+right 'location history forward; zle reset-prompt'
,bindkey -N ctrl+r _,fzf-history-widget
,bindkey cmd+z undo
,bindkey cmd+shift+z redo
,bindkey -N cmd+shift+f ',rg; zle reset-prompt'
