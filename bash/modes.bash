+strict() {
    set -eEu -o pipefail
}


+debug() {
    set -Tx
}


-debug() {
    set +Tx
}
