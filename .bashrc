# -- 'env' languages tools
if command -v pyenv 1>/dev/null 2>&1; then eval "$(pyenv init -)"; fi
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
[ -s "$HOME/.jabba/jabba.sh" ] && . "$HOME/.jabba/jabba.sh"
[ -s "$HOME/.phpbrew/bashrc" ] && . "$HOME/.phpbrew/bashrc"
[ -s "$HOME/.asdf/asdf.sh" ] && . "$HOME/.asdf/asdf.sh"
# --

[ -s "$HOME/.betafcc/bash/functions.bash" ] && . "$HOME/.betafcc/bash/functions.bash"

alias g='e --gui'
alias l=',ls'
alias la=',ls -a'
alias r='ranger'
alias icat="kitty +kitten icat" # TODO: maybe check if running in kitty?
alias poetry_shell='. "$(dirname $(poetry run which python))/activate"'
alias mkcd=',mkcd'

# End here if not in interactive mode
case $- in
    *i*) ;;
      *) return;;
esac

# TODO:
# infinite history
shopt -s autocd
shopt -s checkwinsize
shopt -s globstar
shopt -s histappend

# helpers for the other commands
bind '"\er": redraw-current-line'
bind '"\e^": history-expand-line'

# M-<left> : up dir
bind -x '"\201":"cd .."'
bind '"\e[1;3D":" \C-u \C-a\C-k\201\C-m\C-y\C-a\C-y\ey\C-d\C-h\C-e\er \C-h"'
# M-<right> : select descendent dir
bind -x '"\202":"eval $( ,goto-folder --descend )"'
bind '"\e[1;3C":" \C-u \C-a\C-k\202\C-m\C-y\C-a\C-y\ey\C-d\C-h\C-e\er \C-h"'
# C-x C-d : find dir
bind -x '"\203":"eval $( ,goto-folder --find )"'
bind '"\C-x\C-d":" \C-u \C-a\C-k\203\C-m\C-y\C-a\C-y\ey\C-d\C-h\C-e\er \C-h"'
# # C-x C-f : find
# bind -x '"\204":"eval $( 🔍 )"'
# bind '"\C-x\C-f":" \C-u \C-a\C-k\204\C-m\C-y\C-a\C-y\ey\C-d\C-h\C-e\er \C-h"'
# M-x : paste extended command
bind '"\ex": "`,meta-x`\e\C-e\er"'


# Completions
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

[ -s "$HOME/.asdf/completions/asdf.bash" ] && . "$HOME/.asdf/completions/asdf.bash"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
eval "$(stack --bash-completion-script stack)"
if [ $(command -v pipenv) ]; then eval "$(pipenv --completion)"; fi
source $(dirname $(gem which colorls))/tab_complete.sh


[ -s "$HOME/localrc.bash" ] && . "$HOME/localrc.bash"

source "$HOME/.betafcc/bash/modes.bash"
export -f '+debug'
export -f '+strict'


if [ -s "${HOME}/.betafcc/bash/kitsune/kitsune" ]; then
  source "${HOME}/.betafcc/bash/kitsune/kitsune" activate
fi
