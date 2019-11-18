#!/usr/bin/env sh

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
# polybar -c ~/.config/polybar/config.ini main &

# Launch bar1 and bar2
DISPLAY1="$(xrandr -q | grep 'DVI-D-0\|HDMI-1' | grep " connected" | cut -d ' ' -f1)"
[[ ! -z "$DISPLAY1" ]] && MONITOR="$DISPLAY1" polybar -c ~/.config/polybar/config.ini main &

DISPLAY2="$(xrandr -q | grep 'HDMI-0\|DP-2' | grep " connected" | cut -d ' ' -f1)"
[[ ! -z $DISPLAY2 ]] && MONITOR=$DISPLAY2 polybar -c ~/.config/polybar/config.ini main &
