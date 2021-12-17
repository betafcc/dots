# echo zshrc.zsh
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

autoload -Uz compinit
zstyle ':completion:*' menu select
# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
# partial completion suggestions
zstyle ':completion:*' list-suffixeszstyle ':completion:*' expand prefix suffix
zmodload zsh/complist
autoload -Uz compinit
if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' ${ZDOTDIR:-$HOME}/.zcompdump) ]; then
  compinit
else
  compinit -C
fi
_comp_options+=(globdots)

# kitty + complete setup zsh | source /dev/stdin

zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

source "${PYENV_ROOT}/completions/pyenv.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source "${_DIRNAME}/functions.zsh"
source "${_DIRNAME}/keybindings.zsh"

source "${_DIRNAME}/kitsune.zsh"
kitsune activate

source "${_DIRNAME}/location.zsh"
location history activate

unsetopt BEEP

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
