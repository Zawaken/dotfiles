#!/usr/bin/env sh

test -f ~/.xprofile && source ~/.xprofile

exec autorandr --change &
# exec awesome
exec xmonad
