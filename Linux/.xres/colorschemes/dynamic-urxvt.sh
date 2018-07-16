#!/bin/sh
function reloadx()
{
	xrdb -load ~/.Xresources
	kill -1 $(pidof urxvtd)
}

while [ "$1" != "" ]; do
	case $1 in
		-h|--help)
			echo "This is supposed to apply a colorscheme from the folder: ~/.xres/colorschemes" | lolcat
			exit
			;;
		*)
			if [ ! -f ~/.xres/colorschemes/$1 ]; then				
				echo "$1 is not a theme, why not make it?"
				exit
			else
				cat ~/.xres/colorschemes/$1 > ~/.xres/urxvt
				reloadx
				echo "$1 theme succesfully applied"
			fi
			exit 1
			;;
	esac	
	shift
done
