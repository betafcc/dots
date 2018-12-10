@take() {
    if [ $1 -lt 0 ]
    then
        @take-last $(expr '-1' '*' $1)
    else
        @take-first $1
    fi
}

@take-first() {
    head -$1
}


@take-last() {
    tail -$1
}


@drop() {
    if [ $1 -lt 0 ]
    then
        @drop-last $(expr '-1' '*' $1)
    else
        @drop-first $1
    fi
}


@drop-first() {
    tail -n +$(expr $1 + 1)
}


@drop-last() {
    head -n -$1
}


@every() {
    if [ $1 -lt 0 ]
    then
        tac | every $(expr '-1' '*' $1)
    else
        sed -n "1~${1}p"
    fi
}
