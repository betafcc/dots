I remap:
- Caps Lock to emit Left Alt
- Left Alt to emit Left Ctrl
- Left Ctrl to emit Caps Lock


The easy way is to use Xmodmap, but that [seems to be deprecated in favor of xkb](https://askubuntu.com/questions/325272/permanent-xmodmap-in-ubuntu-13-04/858272#858272)

The *right* way seems to be [defining a new option](https://unix.stackexchange.com/questions/212573/how-can-i-make-backspace-act-as-escape-using-setxkbmap/215062#215062)

But I was already 2 hours in this endeavor so I just modifed `/usr/share/X11/xkb/keycodes/evdev` [as shown here](https://unix.stackexchange.com/questions/245576/using-xkb-to-remap-quote-and-right-control/245580#245580)

The right way to do it is clearely better as aparently it enables to quick switch to the unaltered

Also, an easy way to convert from .Xmodmap seems to be simply registering the normal using `xkbcomp -xkb $DISPLAY normal-keymap` and then `xmodmap .Xmodmap` followed by `xkbcomp -xkb $DISPLAY modified-keymap` and diffing the two as noted [here](https://unix.stackexchange.com/a/202885)
