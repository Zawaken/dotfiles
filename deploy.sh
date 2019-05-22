#!/bin/sh
if [[ $(lsb_release -is) == "Fedora" ]]; then
	echo "installing packages"
elif [[ $(lsb_release -is) == "Antergos" ]]; then
	echo "installing packages"
else
	echo "distro $(lsb_release -is) not supported"
	exit 1
fi

echo "Deploying zshrc and xresources"
ln -s $(pwd)/.zshrc $HOME/.zshrc
ln -s $(pwd)/.xres $HOME
ln -s $(pwd)/.Xresources $HOME/.Xresources
ln -s $(pwd)/.xinitrc $HOME/.xinitrc

echo "Do you want the home i3cfg? [y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
	echo "Deploying home i3cfg"
	mkdir -p $HOME/.config/i3 && ln -s $(pwd)/.config/i3/config $HOME/.config/i3/config
	mkdir -p $HOME/.config/polybar && ln -s $(pwd)/.config/polybar/config $HOME/.config/polybar/config
	ln -s $(pwd)/.config/polybar/polybar.sh $HOME/.config/polybar/polybar.sh
else
	echo "Do you want to deploy the work i3cfg? [y,n]"
	read input2
	if [[ $input == "Y" || $input == "y" ]]; then
		echo "Deploying work i3cfg"
		mkdir -p $HOME/.config/i3 && ln -s $(pwd)/.config/i3/configwork $HOME/.config/i3/config
		mkdir -p $HOME/.config/polybar && ln -s $(pwd)/.config/polybar/config $HOME/.config/polybar/config
		ln -s $(pwd)/.config/polybar/polybar.sh $HOME/.config/polybar/polybar.sh
	else
		echo "No i3cfg for you then"
	fi
fi

echo "Deploying vimrc"
ln -s $(pwd)/.vimrc $HOME/.vimrc
mkdir -p $HOME/.config/nvim && ln -s $(pwd)/.config/nvim/init.vim $HOME/.config/nvim/init.vim


echo "Deploying \$HOME/bin folder"
ln -s $(pwd)/bin/i3-lock $HOME/bin
ln -s $(pwd)/bin/ix $HOME/bin/ix
ln -s $(pwd)/bin/olkborder.sh $HOME/bin/olkborder.sh
ln -s $(pwd)/bin/redshift.sh $HOME/bin/redshift.sh


# ln -s $(pwd) $HOME
