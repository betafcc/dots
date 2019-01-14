export PYENV_ROOT="$HOME/.pyenv"
PATH="$PYENV_ROOT/bin:$HOME/.poetry/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export PATH

export EDITOR="e"


[ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
[ -s "/home/betafcc/.jabba/jabba.sh" ] && . "/home/betafcc/.jabba/jabba.sh"
