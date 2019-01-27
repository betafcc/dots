if command -v pyenv 1>/dev/null 2>&1; then eval "$(pyenv init -)"; fi


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$HOME/.jabba/jabba.sh" ] && . "$HOME/.jabba/jabba.sh"
[ -s "$HOME/.phpbrew/bashrc" ] && . "$HOME/.phpbrew/bashrc"
[ -s "$HOME/.asdf/asdf.sh" ] && . "$HOME/.asdf/asdf.sh"
[ -s "$HOME/.fzf.bash" ] && . "$HOME/.fzf.bash"


# default dir lister
_l() { exa --color=always --icons --group-directories-first "$@" | less -RXF; }
alias l='_l'
alias la='_l -a'
alias r='ranger'
alias icat="kitty +kitten icat" # TODO: maybe check if running in kitty?
alias poetry_shell='. "$(dirname $(poetry run which python))/activate"'
mkcd() { mkdir -p "${1}"; cd "${1}"; }


# End here if not in interactive mode
case $- in
    *i*) ;;
      *) return;;
esac


# TODO:
# infinite history
# nicer less
shopt -s autocd
shopt -s checkwinsize
shopt -s globstar

bind -x '"\201":"cd .."'
bind '"\e[1;3D":" \C-u \C-a\C-k\201\C-m\C-y\C-a\C-y\ey\C-d\C-h\C-e\er \C-h"'
bind -x '"\202":"eval $( 📂 )"'
bind '"\e[1;3C":" \C-u \C-a\C-k\202\C-m\C-y\C-a\C-y\ey\C-d\C-h\C-e\er \C-h"'
bind -x '"\203":"eval $( 📂 -v )"'
bind '"\C-x\C-d":" \C-u \C-a\C-k\203\C-m\C-y\C-a\C-y\ey\C-d\C-h\C-e\er \C-h"'
bind -x '"\204":"eval $( 🔍 )"'
bind '"\C-x\C-f":" \C-u \C-a\C-k\204\C-m\C-y\C-a\C-y\ey\C-d\C-h\C-e\er \C-h"'


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


[ -s "$HOME/localrc.bash" ] && . "$HOME/localrc.bash"

source "$HOME/.betafcc/bash/modes.sh"
export -f '+debug'
export -f '+strict'
# +prompt powerline
