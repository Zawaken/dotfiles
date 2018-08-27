# Zawaken's zshrc
case $- in
	*i*) ;;
	*) return;;
esac

export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="miloshadzic"

source $ZSH/oh-my-zsh.sh

alias ix='$HOME/ix'
alias pac='sudo pacman'
alias adb='$HOME/Documents/platform-tools/adb'
alias fastboot='$HOME/Documents/platform-tools/fastboot'
alias fetch='neofetch --ascii_distro arch'
alias ridiculous-name='ncmpcpp'
alias i3c='nvim ~/.config/i3/config'
alias reloadx='xrdb -load ~/.Xresources'
alias terminal-colors='~/.xres/colorschemes/dynamic-urxvt.sh'
alias :q='exit'
alias please='sudo $(fc -ln -1)'
alias fuck='sudo $(fc -ln -1)'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
plugins=(
  git
  zsh-autosuggestions
  zsh-history-substring-search
  zsh-syntax-highlighting
)
