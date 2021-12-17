export NVM_LAZY_LOAD=true
source ~/.zsh-nvm/zsh-nvm.plugin.zsh

[ -r $YVM_DIR/yvm.sh ] && . $YVM_DIR/yvm.sh

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
