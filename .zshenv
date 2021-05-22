export EDITOR='emacs -nw'
export DENO_INSTALL="${HOME}/.deno"
export PYENV_ROOT="${HOME}/.pyenv"

PATH="${PATH}:${PYENV_ROOT}/bin"
PATH="${PATH}:${DENO_INSTALL}/bin"
PATH="${PATH}:${HOME}/.cargo/bin"
PATH="${PATH}:${HOME}/.rvm/bin"
PATH="${PATH}:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
PATH="${PATH}:${HOME}/.betafcc/bin"
export PATH
# --

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
