#!/usr/bin/env sh

test -f ~/.xprofile && source ~/.xprofile

exec bspwm
