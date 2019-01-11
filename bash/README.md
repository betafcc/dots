## Notes to self


### On evaluated rc-files

from this awesome [stack overflow answer](https://stackoverflow.com/questions/9953005/should-the-bashrc-in-the-home-directory-load-automatically/9954208#9954208)

```
                     +-----------------+   +------FIRST-------+   +-----------------+
                     |                 |   | ~/.bash_profile  |   |                 |
login shell -------->|  /etc/profile   |-->| ~/.bash_login ------>|  ~/.bashrc      |
                     |                 |   | ~/.profile       |   |                 |
                     +-----------------+   +------------------+   +-----------------+
                     +-----------------+   +-----------------+
                     |                 |   |                 |
interactive shell -->|  ~/.bashrc -------->| /etc/bashrc     |
                     |                 |   |                 |
                     +-----------------+   +-----------------+
                     +-----------------+
                     |                 |
logout shell ------->|  ~/.bash_logout |
                     |                 |
                     +-----------------+
```

**Note**

1. `[]-->[]` means `source by workflow` (Automatically).
- `[--->[]` means `source by convention` （Manually. If not, nothing happen.）.
- `FIRST` means `find the first available, ignore rest`

### On data passing

The only realiable way I know to pass data around in posix shell functions, without worrying about unquoting and wrongly splitting by space/tab/new line, and without hacking the `IFS` or falling back to parsing/unparsing, is to use the argument list

[From this answer](https://stackoverflow.com/a/3990540):

```sh
function identity() {
  "$@"
}

set -x
identity identity identity identity identity echo Hello \"World\"
# + identity identity identity identity identity echo Hello '"World"'
# + identity identity identity identity echo Hello '"World"'
# + identity identity identity echo Hello '"World"'
# + identity identity echo Hello '"World"'
# + identity echo Hello '"World"'
# + echo Hello '"World"'
# Hello "World"
```

**Note**

#### Variable setting is unsafe:


```
echo_each() {
    for arg in "$@"; do
        echo "${arg}"
    done
}

echo_each a b 'c d' e
# a
# b
# c d  <- nice
# e
```

Setting `args="$@"`, iterating `"${args}"`
```
echo_each() {
    args=$@
    for arg in "${args}"; do
        echo "${arg}"
    done
}

echo_each a b 'c d' e
# a b c d e
```

Setting `args="$@"`, iterating `${args}`
```
echo_each() {
    args="$@"
    for arg in ${args}; do
        echo "${arg}"
    done
}

echo_each a b 'c d' e
# a
# b
# c
# d
# e
```

Returning with `echo` or `printf` relies on `IFS` for separation so it's not safe either.

Use `set -- "$@" 'other arg'` and continuation-style as much as possible

