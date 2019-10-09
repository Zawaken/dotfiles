#!/bin/sh
dir="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

if [[ $(lsb_release -is) == "Fedora" ]]; then
	echo "installing packages"
elif [[ $(lsb_release -is) == "Antergos" ]]; then
	echo "installing packages"
else
	echo "distro $(lsb_release -is) not supported"
	exit 1
fi

for f in * .*; do
	if ! [[ "$f" =~ ^(\.|\.\.|\.git|README\.md|\.2ndkeyboard\.py|deploy|\.sharenix\.json|\.gitignore|backup)$ ]]; then
		if [[ -d "$f" ]]; then
			(set -x; cp -rsvu ${dir}/${f} ${HOME}/)
		else
			(set -x; cp -svu ${dir}/${f} ${HOME}/${f})
		fi
	fi
done


# cp -rs cp -rs ${DOTDIR} $HOME
