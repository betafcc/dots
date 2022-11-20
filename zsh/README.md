ZSH Options: https://zsh.sourceforge.io/Doc/Release/Options.html

A Guide to the Zsh Line Editor with Examples: https://thevaluable.dev/zsh-line-editor-configuration-mouseless


## open shell with no environment

`env -i zsh -f`

https://unix.stackexchange.com/questions/579104/start-interactive-zsh-without-running-any-configuration-files-like-zshrc

## trace rc files sourced

`env -i zsh -l -o sourcetrace`


https://www.csse.uwa.edu.au/programming/linux/zsh-doc/zsh_3.html
https://zsh.sourceforge.io/Doc/Release/Invocation.html
https://zsh.sourceforge.io/Doc/Release/Options.html


Print only the file names:
```zsh
{ env -i zsh -l -i -o sourcetrace -c 'exit' 2>&1 1>/dev/null } | sed -n 's/+\(.*\):[0-9]*>[[:space:]]*<sourcetrace>$/\1/p'
```

## zsh flags

```
-i : interactive mode
-l : Login mode
-p : Privileged mode
-r : Restricted mode
-t : Single command mode
-s : Execute commands from stdin
--globalrcs
--rcs
-d | --no-globalrcs
-f | --no-rcs
```
https://zsh.sourceforge.io/Doc/Release/Options.html#Shell-State
https://unix.stackexchange.com/questions/131716/start-zsh-with-a-custom-zshrc


## Loading Order

https://medium.com/@rajsek/zsh-bash-startup-files-loading-order-bashrc-zshrc-etc-e30045652f2e
https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/

```
+----------------+-----------+-----------+------+
|                |Interactive|Interactive|Script|
|                |login      |non-login  |      |
+----------------+-----------+-----------+------+
|/etc/zshenv     |    A      |    A      |  A   |
+----------------+-----------+-----------+------+
|~/.zshenv       |    B      |    B      |  B   |
+----------------+-----------+-----------+------+
|/etc/zprofile   |    C      |           |      |
+----------------+-----------+-----------+------+
|~/.zprofile     |    D      |           |      |
+----------------+-----------+-----------+------+
|/etc/zshrc      |    E      |    C      |      |
+----------------+-----------+-----------+------+
|~/.zshrc        |    F      |    D      |      |
+----------------+-----------+-----------+------+
|/etc/zlogin     |    G      |           |      |
+----------------+-----------+-----------+------+
|~/.zlogin       |    H      |           |      |
+----------------+-----------+-----------+------+
|                |           |           |      |
+----------------+-----------+-----------+------+
|                |           |           |      |
+----------------+-----------+-----------+------+
|~/.zlogout      |    I      |           |      |
+----------------+-----------+-----------+------+
|/etc/zlogout    |    J      |           |      |
+----------------+-----------+-----------+------+
```

## redirection

how to pipe only stderr: https://unix.stackexchange.com/questions/265061/how-can-i-pipe-only-stderr-in-zsh
redirection: https://zsh.sourceforge.io/Doc/Release/Redirection.html#Multios

https://catonmat.net/bash-one-liners-explained-part-three#:~:text=When%20bash%20starts%20it%20opens,them%20and%20read%20from%20them.

https://www.oreilly.com/library/view/bash-cookbook/0596526784/ch02s20.html


## Misc Notes

If you set `export EDITOR=vim`, zsh will set the zle keymap to be vim, but where?

