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
