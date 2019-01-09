# 'modes' are Commands meant to modify the caller environment
#
# Conventions:
#     '+<my_mode>' sets options and variables on the caller environment
#     '-<my_mode>' removes options and variable on the caller environment
#
# '+' and '-' operations are meant to be *idempotent* ie, running one time
# should be the same as consecutively running 1000 times
#
# Note that running a '+<my_mode>' followed by '-<my_mode>'
# does NOT need to guarantee the environment will be the same as before,
# ie, '-<my_mode>' is meant to negate whats set on '+<my_mode>',
# even if the shell had common options and/or variables already set


# My settings for making a bash script safer
#
# References:
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
# http://redsymbol.net/articles/unofficial-bash-strict-mode
# https://github.com/mrzool/bash-sensible/blob/master/sensible.bash
+strict() {
    # exit immediately if error
    set -e
    # commands inherit traps on ERR
    set -E
    # error if reference unset variable
    set -u
    # disable file overwrite with '>' redirection
    # explicitly use '>|' instead
    set -o noclobber
    # don't mask errors in pipeline
    set -o pipefail
}


+debug() {
    # -x prints trace of commands
    # -T makes trap on DEBUG and RETURN inherited by commands
    set -Tx
}


-debug() {
    set +Tx
}


# prompt and ps1 definitions
{
    __DEFAULT_PS1="${PS1}"


    # eg: `+prompt powerline`
    +prompt() {
        local command="$(prompt::update_command "${1}")"

        if ! command -v "${command}" > /dev/null; then
            (>&2 echo "'${1}' prompt not set up")
            return 127
        fi

        if ! prompt::is_active "${command}"; then
            PROMPT_COMMAND="${command};$PROMPT_COMMAND"
        fi
    }


    -prompt() {
        local command="$(prompt::update_command "${1}")"
        if prompt::is_active "${command}"; then
            PROMPT_COMMAND="${PROMPT_COMMAND/${command};}"
            +ps1::default
        fi
    }


    prompt::update_command() {
        echo "+ps1::${1}"
    }

    prompt::is_active() {
        ! [[ $TERM != linux && ! $PROMPT_COMMAND =~ "${1}" ]]
    }


    +ps1::default() {
        PS1="${__DEFAULT_PS1}"
    }

    +ps1::powerline() {
        PS1=$(powerline-rs --shell bash $?)
    }
}
