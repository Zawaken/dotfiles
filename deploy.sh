#!/bin/sh

i3_dotfiles () {
	echo "installing i3 dotfiles"
	
	stow -vv -R -S bin compton dunst i3 nvim polybar ranger redshift sxhkd vim x zsh
}

all_dotfiles () {
	echo "installing all dotfiles"

	stow -vv -R -S bin compton cwm dunst i3 nvim polybar ranger redshift sxhkd vim x xmobbarrc zsh
}
cwm_dotfiles () {
	echo "installing cwm dotfiles"

	stow -vv -R -S bin compton cwm dunst nvim ranger redshift sxhkd vim x xmobbarrc zsh
}

echo "Do you want to install i3, cwm or all dotfiles? [i/c/a]"
read input
if [[ $input == "i" || $input == "I" ]]; then
	i3_dotfiles
	echo ''
	echo "i3 dotfiles have been installed"
elif [[ $input == "c" || $input == "C" ]]; then
	cwm_dotfiles
	echo ''
	echo "cwm dotfiles have been installed"
elif [[ $input == "a" || $input == "A" ]]; then
	all_dotfiles
	echo ''
	echo "all dotfiles have been installed"
else
	echo "input either i(I), c(C) or a(A)"
	exit 1
fi
