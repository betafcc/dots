# zmodload zsh/zprof

# export VISUAL="emacs -Q -nw"
# export EDITOR="emacs -Q -nw"

export VOLTA_HOME="${HOME}/.volta"
export PYENV_ROOT="${HOME}/.pyenv"
export PYENV_SHELL=zsh

_PATH="${_PATH}:/opt/homebrew/bin"
_PATH="${_PATH}:${PYENV_ROOT}/bin"
_PATH="${_PATH}:${HOME}/.poetry/bin"
_PATH="${_PATH}:${VOLTA_HOME}/bin"
_PATH="${_PATH}:${HOME}/.betafcc/bin"
_PATH="${_PATH}:${HOME}/.betafcc/deno"
_PATH="${_PATH}:${HOME}/.betafcc/bin/fzf-scripts"
_PATH="${_PATH}:${HOME}/.local/bin"
_PATH="${_PATH}:${HOME}/.ghcup/bin"
_PATH="${_PATH}:${HOME}/.cabal/bin"
export PATH="${_PATH}:${PATH}"

# # ghcup paths setup
# [ -f "${HOME}/.ghcup/env" ] && source "${HOME}/.ghcup/env" # ghcup-env
# added manually up there instead

# awesome less presets from
# https://www.topbug.net/blog/2016/09/27/make-gnu-less-more-powerful/
export LESS='-i -J -M -R -W -x4 -X -z-4'
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# # For kitty, see: https://github.com/kovidgoyal/kitty/issues/469#issuecomment-419406438
# export GLFW_IM_MODULE=ibus

# # https://stackoverflow.com/questions/49436922/getting-error-while-trying-to-run-this-command-pipenv-install-requests-in-ma
# export LANG="en_US.UTF-8"
# export LC_ALL="en_US.UTF-8"
# export LC_CTYPE="en_US.UTF-8"

export PIPENV_VENV_IN_PROJECT=true
export POETRY_VIRTUALENVS_IN_PROJECT=true

# export LDFLAGS="-L/opt/homebrew/opt/llvm@14/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/llvm@14/include"

# # cabal-fmt needed this version, idk if I should keep it here or just one-off there
# export LDFLAGS="-L/opt/homebrew/opt/llvm@12/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/llvm@12/include"

# export PATH="/opt/homebrew/opt/llvm@12/bin:$PATH"
