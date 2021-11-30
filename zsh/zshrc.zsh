_DIRNAME=${0:a:h}

# this messes up my keymap,
# but only when I enter another instance of zsh for some reason
# (ie, when I'm on zsh and then run 'zsh' again)
# why?
# export EDITOR=vim

export DENO_INSTALL="${HOME}/.deno"
export PYENV_ROOT="${HOME}/.pyenv"
export ANDROID_HOME="${HOME}/Library/Android/sdk"

_PATH="${PYENV_ROOT}/shims"
_PATH="${_PATH}:${PYENV_ROOT}/bin"
_PATH="${_PATH}:${DENO_INSTALL}/bin"
_PATH="${_PATH}:${HOME}/.cargo/bin"
_PATH="${_PATH}:${HOME}/.rvm/bin"
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

source ~/.zsh-nvm/zsh-nvm.plugin.zsh

# ghcup-env
[ -f "${HOME}/.ghcup/env" ] && source "${HOME}/.ghcup/env"

export YVM_DIR=/usr/local/opt/yvm
[ -r $YVM_DIR/yvm.sh ] && . $YVM_DIR/yvm.sh

export YVM_DIR="${HOME}/.yvm"

export PYENV_SHELL=zsh
source "${PYENV_ROOT}/completions/pyenv.zsh"
command pyenv rehash 2>/dev/null
pyenv() {
    local command
    command="${1:-}"
    if [ "$#" -gt 0 ]; then
        shift
    fi

    case "$command" in
    rehash | shell)
        eval "$(pyenv "sh-$command" "$@")"
        ;;
    *)
        command pyenv "$command" "$@"
        ;;
    esac
}

autoload -Uz compinit
zstyle ':completion:*' menu select
# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
# partial completion suggestions
zstyle ':completion:*' list-suffixeszstyle ':completion:*' expand prefix suffix
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# kitty + complete setup zsh | source /dev/stdin

zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source "${_DIRNAME}/functions.zsh"
source "${_DIRNAME}/keybindings.zsh"

source "${_DIRNAME}/kitsune.zsh"
kitsune activate

source "${_DIRNAME}/location.zsh"
location history activate

unsetopt BEEP

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
