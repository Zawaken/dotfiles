#!/usr/bin/env sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

test -f ~/.xprofile && source ~/.xprofile
DESKTOP=xmonad

# increase repeat rate
xset r rate 300 50 &

# set cursor so it doesn't turn into an X on root window
xsetroot -cursor_name left_ptr

autorandr --change &

feh --bg-scale $HOME/.config/wall.png &

if test "${DESKTOP}" = "xmonad"; then
  trayer --edge top --align right --SetDockType true --SetPartialStrut false --expand true --widthtype request --transparent true \
    --tint 0x0D1117 --height 30 --heighttype pixel --monitor "primary" --margin 20 --distance 5 --padding 0 & # &
fi


if grep -q "=Gentoo" /etc/os-release; then
  exec dbus-launch ${DESKTOP}
else
  exec ${DESKTOP}
fi
