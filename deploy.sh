#!/bin/sh
DOTDIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

if [[ $(lsb_release -is) == "Fedora" ]]; then
	echo "installing packages"
elif [[ $(lsb_release -is) == "Antergos" ]]; then
	echo "installing packages"
else
	echo "distro $(lsb_release -is) not supported"
	exit 1
fi

echo "Deploying zshrc and xresources"
cp -rs ${DOTDIR}/.zshrc $HOME/.zshrc
cp -rs ${DOTDIR}/.xres $HOME
cp -rs ${DOTDIR}/.Xresources $HOME/.Xresources
cp -rs ${DOTDIR}/.xinitrc $HOME/.xinitrc

echo "Do you want the home i3cfg? [y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
	echo "Deploying home i3cfg"
	mkdir -p $HOME/.config/i3 && cp -rs ${DOTDIR}/.config/i3/config $HOME/.config/i3/config
	mkdir -p $HOME/.config/polybar && cp -rs ${DOTDIR}/.config/polybar/config $HOME/.config/polybar/config
	cp -rs ${DOTDIR}/.config/polybar/polybar.sh $HOME/.config/polybar/polybar.sh
else
	echo "Do you want to deploy the work i3cfg? [y,n]"
	read input2
	if [[ $input2 == "Y" || $input == "y" ]]; then
		echo "Deploying work i3cfg"
		mkdir -p $HOME/.config/i3 && cp -rs ${DOTDIR}/.config/i3/configwork $HOME/.config/i3/config
		mkdir -p $HOME/.config/polybar && cp -rs ${DOTDIR}/.config/polybar/config $HOME/.config/polybar/config
		cp -rs ${DOTDIR}/.config/polybar/polybar.sh $HOME/.config/polybar/polybar.sh
	else
		echo "No i3cfg for you then"
	fi
fi

echo "Deploying vimrc"
cp -rs ${DOTDIR}/.vimrc $HOME/.vimrc
mkdir -p $HOME/.config/nvim && cp -rs ${DOTDIR}/.config/nvim/init.vim $HOME/.config/nvim/init.vim


echo "Deploying \$HOME/bin folder"
mkdir $HOME/bin
cp -rs ${DOTDIR}/bin $HOME/bin/dots

# cp -rs cp -rs ${DOTDIR} $HOME
