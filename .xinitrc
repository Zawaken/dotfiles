#!/usr/bin/env sh

DESKTOP="xmonad"
test -f ~/.xprofile && source ~/.xprofile

autorandr --change &
feh --bg-scale $HOME/.config/wall.png &
if test "${DESKTOP}" = "xmonad"; then
  trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 5 --transparent false --tint 0x0D1117 --height 30 --monitor "primary" &
fi

exec "${DESKTOP}"
