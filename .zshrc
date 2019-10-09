# Zawaken's zshrc
case $- in
	*i*) ;;
	*) return;;
esac

ANTIGEN=$HOME/.antigen/
[ -f $ANTIGEN/antigen.zsh ] || git clone\
	https://github.com/zsh-users/antigen.git $ANTIGEN
if [[ -f $ANTIGEN/antigen.zsh ]]; then
	source $ANTIGEN/antigen.zsh
	antigen use oh-my-zsh
	antigen bundle archlinux
	antigen bundle colorize
	antigen bundle command-not-found
	antigen bundle common-aliases
	antigen bundle desyncr/auto-ls
	antigen bundle dnf
	antigen bundle docker
	antigen bundle git
	antigen bundle git-extras
	antigen bundle systemd
	antigen bundle thefuck
	antigen bundle tmux
	antigen bundle unixorn/autoupdate-antigen.zshplugin
	antigen bundle yum
	antigen bundle zsh-users/zsh-autosuggestions
	antigen bundle zsh-users/zsh-history-substring-search
	antigen bundle zsh-users/zsh-syntax-highlighting

	antigen theme romkatv/powerlevel10k

	antigen apply
fi

# Exporting variables
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH
export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim

# Powerlevel9k theme options
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir dir_writable vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)

# Aliases
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
alias reload='source $HOME/.zshrc'
alias reloadx='xrdb -load ~/.Xresources'
alias terminal-colors='$HOME/.xres/colorschemes/dynamic-urxvt.sh'
alias :q='exit'
alias please='sudo $(fc -ln -1)'
alias jf='journalctl -f'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
