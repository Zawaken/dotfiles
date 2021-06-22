#!/bin/sh
setxkbmap -v no &
feh --bg-scale $HOME/.config/wall.png &
xrdb $HOME/.Xresources
xsetroot -cursor_name left_ptr
if ! pgrep "picom" > /dev/null 2>&1 ; then
  picom -b &
fi
xrandr --output DisplayPort-0 --primary --mode 2560x1440 --pos 1920x0 --rotate normal --output HDMI-A-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DisplayPort-1 --mode 1920x1080 --pos 4480x0 --rotate normal --output DVI-I-0 --off --output DP-1 --off --output DP-0 --off &
