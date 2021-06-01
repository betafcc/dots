_DIRNAME=${0:a:h}

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

autoload -Uz compinit
zstyle ':completion:*' menu select
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

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
