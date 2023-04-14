#!/usr/bin/env sh

test -f ~/.xprofile && source ~/.xprofile
DESKTOP=xmonad

# increase repeat rate
xset r rate 300 50 &

# set cursor so it doesn't turn into an X on root window
xsetroot -cursor_name left_ptr

autorandr --change &

feh --bg-scale $HOME/.config/wall.png &

if test "${DESKTOP}" = "xmonad"; then
  trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 5 --transparent false --tint 0x0D1117 --height 30 --monitor "primary" &
fi


if grep -q "=Gentoo" /etc/os-release; then
  exec dbus-launch ${DESKTOP}
else
  exec ${DESKTOP}
fi
