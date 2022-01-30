#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

if test -z "$(pgrep -x polybar)"; then
  for MONITOR in $(polybar --list-monitors | cut -d" " -f1 | cut -d":" -f1); do
    IS_PRIMARY="$(polybar --list-monitors | grep "${MONITOR}" | cut -d" " -f3)"
    if [[ $IS_PRIMARY == *"primary"* ]]; then
      TRAY=right
    else
      TRAY=none
    fi
    TRAY=$TRAY MONITOR=$MONITOR polybar --reload -c $HOME/.config/polybar/config.ini xmonad &
  done
else
  polybar-msg cmd restart
fi
