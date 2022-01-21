# zmodload zsh/zprof

# this messes up my keymap,
# but only when I enter another instance of zsh for some reason
# (ie, when I'm on zsh and then run 'zsh' again)
# why?
# export EDITOR=vim

export DENO_INSTALL="${HOME}/.deno"
export PYENV_ROOT="${HOME}/.pyenv"
export ANDROID_HOME="${HOME}/Library/Android/sdk"
export YVM_DIR=/usr/local/opt/yvm
export YVM_DIR="${HOME}/.yvm"
export PYENV_SHELL=zsh

_PATH="${_PATH}:${PYENV_ROOT}/shims"
_PATH="${_PATH}:${PYENV_ROOT}/bin"
_PATH="${_PATH}:${HOME}/.poetry/bin:$PATH"
_PATH="${_PATH}:${DENO_INSTALL}/bin"
_PATH="${_PATH}:${HOME}/.cargo/bin"
_PATH="${_PATH}:${HOME}/.rvm/bin"
_PATH="${_PATH}:${HOME}/.cabal/bin"
_PATH="${_PATH}:${HOME}/.ghcup/bin"
_PATH="${_PATH}:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
_PATH="${_PATH}:${HOME}/.betafcc/bin"
_PATH="${_PATH}:${ANDROID_HOME}/emulator"
_PATH="${_PATH}:${ANDROID_HOME}/tools"
_PATH="${_PATH}:${ANDROID_HOME}/tools/bin"
_PATH="${_PATH}:${ANDROID_HOME}/platform-tools"
_PATH="${_PATH}:${HOME}/.local/bin"
export PATH="${_PATH}:${PATH}"
# --

export PIPENV_VENV_IN_PROJECT=true

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

# --

# For kitty, see: https://github.com/kovidgoyal/kitty/issues/469#issuecomment-419406438
export GLFW_IM_MODULE=ibus

# https://stackoverflow.com/questions/49436922/getting-error-while-trying-to-run-this-command-pipenv-install-requests-in-ma
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"