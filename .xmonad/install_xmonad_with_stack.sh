#!/bin/bash
# Copied mostly from https://gitlab.com/kellegram/kellmonad/-/blob/master/install_xmonad_with_stack.sh

# make .xmonad directory if it doesn't exist
if [ ! -d $HOME/.xmonad/ ]; then
  mkdir -p $HOME/.xmonad
fi

# check if xmonad.hs exists
if [ ! -f $HOME/.xmonad/xmonad.hs ]; then
  echo "No xmonad.hs file found, do you want to continue anyway?"
  read;
  if [ ${REPLY} == yes ]; then
    echo "If you do not add a custom xmonad.hs file, you will be met with a black screen after starting x"
    break
  else
    echo "exiting."
    exit
  fi
fi

# Basic packages
if ! yay -S --noconfirm polybar picom-jonaburg-git dunst rofi alacritty autorandr feh \
  git xorg-server xorg-apps xorg-xinit xorg-xmessage libx11 libxft libxinerama libxrandr \
  libxss pkgconf xmonad-log
then
  echo "Installing packages failed."
  echo "Try rerunning the script."
  exit
fi

# Install Stack
yay -S --noconfirm stack

# Enter the .xmonad folder and pull latest version of xmonad and xmonad-contrib
cd "$HOME/.xmonad" || {echo "Failed to enter $HOME/.xmonad"; exit;}

# Check is xmonad and xmonad-contrib exists in the directory, and git clone them if they don't
if [ ! -d $HOME/.xmonad/xmonad ]; then
  git clone "https://github.com/xmonad"
fi
if [ ! -d $HOME/.xmonad/xmonad-contrib ]; then
  git clone "https://github.com/xmonad-contrib"
fi

# Initialize the "project"
stack init

# install everything with stack
if stack install
  echo "Stack install succeded"
else
  echo "Stack install failed, aborting"
  exit
fi

# check for dbus and in xmonad.hs install the dbus hackage package if needed
if [ grep -i "dbus" xmonad.hs ]; then
  stack install dbus
fi

if ! xmonad --recompile; then
  echo "\nxmonad failed to compile."
fi
