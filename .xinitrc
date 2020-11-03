#compton -b -f --config ~/.config/compton.conf &
#compton &
xrdb -load ~/.Xresources
#xsetkbmap no
#feh --bg-scale ~/Pictures/wallpapers/wall.png
#sxhkd &
eval $(ssh-agent)
systemctl --user import-environment DISPLAY
#urxvtd -q -o -f
#exec cwm
#exec 2bwm
#exec i3
exec bspwm
#exec dbus-launch --autolaunch=$(cat /var/lib/dbus/machine-id) bspwm
#/usr/libexec/polkit-gnome-authentication-agent-1 &
