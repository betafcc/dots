take() {
    if [ $1 -lt 0 ]; then
        take_last $((-1 * $1))
    else
        take_first "${1}"
    fi
}


take_first() {
    head "-${1}"
}


take_last() {
    tail "-${1}"
}


drop() {
    if [ "${1}" -lt 0 ]; then
        drop_last $((-1 * $1))
    else
        drop_first "${1}"
    fi
}


drop_first() {
    tail -n +$(($1 + 1))
}


drop_last() {
    head -n "-${1}"
}


every() {
    if [ "${1}" -lt 0 ]; then
        tac | every $((-1 * $1))
    else
        sed -n "1~${1}p"
    fi
}
