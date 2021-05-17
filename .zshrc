# reference: https://unix.stackexchange.com/a/273863
HISTFILE="${HOME}/.zsh_my_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST              # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY       # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY          # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS       # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a line previously found.
setopt HIST_IGNORE_SPACE      # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS      # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY            # Don't execute immediately upon history expansion.
setopt HIST_BEEP              # Beep when accessing nonexistent history.

,mkcd() {
  mkdir -p "${1}"
  cd "${1}"
}

,jupyter() {
  # pipenv run jupyter lab \
  #   --browser='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --app="%s"'
  pipenv run jupyter lab \
    --browser=',browser %s'
}

,history() {
    fc -i -l 1
}

_,descend() {
  eval $( ,goto-folder --descend )
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

alias mkcd=',mkcd'

source "${HOME}/.betafcc/kitsune"
kitsune-activate
