#!/bin/sh
function switch()
{
	rm ~/.xres/urxvt
	touch ~/.xres/urxvt
}
function reloadx()
{
	xrdb -load ~/.Xresources
	kill -1 $(pidof urxvtd)
}

while [ "$1" != "" ]; do
	PARAM=`echo $1 | awk -F= '{print $1}'`
	VALUE=`echo $1 | awk -F= '{print $2}'`
	case $PARAM in
		solarized)
			switch
			cat ~/.xres/colorschemes/solarized >> ~/.xres/urxvt
			reloadx
			echo "urxvt theme changed to $1"
			exit
			;;
		green)
			switch
			cat ~/.xres/colorschemes/green >> ~/.xres/urxvt
			reloadx
			echo "urxvt theme changed to $1"
			exit
			;;
		felix)
			switch
			cat ~/.xres/colorschemes/felix >> ~/.xres/urxvt
			reloadx
			echo "urxvt theme changed to $1"
			exit
			;;
		*)
			echo "$1 is not a theme"
			echo "try solarized, green or felix"
			exit 1
			;;
	esac
	shift
done
