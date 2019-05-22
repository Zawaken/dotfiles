# Zawaken's zshrc
case $- in
	*i*) ;;
	*) return;;
esac

plugins=(
  git
  zsh-autosuggestions
  zsh-history-substring-search
  zsh-syntax-highlighting
)

export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH
export ZSH=$HOME/.oh-my-zsh
export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim

# ZSH_THEME="miloshadzic"
# ZSH_THEME="bira"
ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir dir_writable vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)

source $ZSH/oh-my-zsh.sh

alias vim='nvim'
alias vi='nvim'
alias ix='$HOME/ix'
alias pac='sudo pacman'
alias adb='$HOME/Documents/platform-tools/adb'
alias fastboot='$HOME/Documents/platform-tools/fastboot'
alias fetch='neofetch --ascii_distro arch'
alias ridiculous-name='ncmpcpp'
alias i3c='vim $HOME/.config/i3/config'
alias polycfg='vim $HOME/.config/polybar/config'
alias reloadx='xrdb -load ~/.Xresources'
alias terminal-colors='$HOME/.xres/colorschemes/dynamic-urxvt.sh'
alias :q='exit'
alias please='sudo $(fc -ln -1)'
alias fuck='sudo $(fc -ln -1)'
alias dnfu='sudo dnf update'
alias jf='journalctl -f'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
