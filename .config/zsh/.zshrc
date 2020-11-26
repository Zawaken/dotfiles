# Zawaken's zshrc {{{
# vim:foldmethod=marker
case $- in
	*i*) ;;
	*) return;;
esac
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
zstyle :compinstall filename '/home/zawaken/.zshrc'

autoload -Uz compinit
compinit

# }}}
# --- Variables --- # {{{
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
HIST_STAMPS="dd.mm.yyyy"
bindkey -e
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$HOME/.gem/ruby/2.6.0/bin:$PATH
export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim
export BSPWM_VIM_INSERT=#FF0000
export BSPWM_VIM_NORMAL=#00FF00
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [ ! -S ~/.ssh/ssh_auth_sock ]; then
  eval `ssh-agent`
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l > /dev/null || ssh-add
# }}}
# --- Functions --- # {{{
pastor() {
	[[ "$1" ]] || { echo "Error: Missing file" >&2; return 1}
	curl -F "a=@$1" "${2:-https://p.btrfs.no}"
}
#}}}
# --- Plugins --- # {{{
# --- Antigen --- # {{{
ANTIGEN=$HOME/.config/.antigen/
[ -f $ANTIGEN/antigen.zsh ] || git clone\
	https://github.com/zsh-users/antigen.git $ANTIGEN
if [[ -f $ANTIGEN/antigen.zsh ]]; then
	source $ANTIGEN/antigen.zsh
	antigen use oh-my-zsh
	antigen bundle archlinux
	antigen bundle zpm-zsh/colorize
	antigen bundle command-not-found
	antigen bundle common-aliases
	antigen bundle chrissicool/zsh-256color
	antigen bundle dnf
	antigen bundle docker
	antigen bundle akarzim/zsh-docker-aliases
	antigen bundle git
	antigen bundle git-extras
	antigen bundle MichaelAquilina/zsh-you-should-use
	antigen bundle systemd
	antigen bundle thefuck
	antigen bundle tmux
	# antigen bundle unixorn/autoupdate-antigen.zshplugin
	antigen bundle yum
	antigen bundle zdharma/fast-syntax-highlighting
	antigen bundle zdharma/zsh-diff-so-fancy
	antigen bundle zsh-users/zsh-autosuggestions
	antigen bundle zsh-users/zsh-history-substring-search
	# antigen bundle zsh-users/zsh-syntax-highlighting

	# antigen prompt theme
	# antigen theme romkatv/powerlevel10k
	antigen theme miloshadzic

	antigen apply
fi
# }}}
# --- Antibody --- # {{{

#command -v antibody > /dev/null 2>&1 \
#  || (echo "Installing Antibody."; curl -sfL -v https://raw.githubusercontent.com/getantibody/installer/master/install | sudo sh -v -s - -b /usr/local/bin -d) \
#  && source <(antibody init)
## heredoc must be indented with tabs
#antibody bundle <<-EOBUNDLES
#	robbyrussell/oh-my-zsh path:plugins/git
#	robbyrussell/oh-my-zsh path:plugins/git-extras
#	robbyrussell/oh-my-zsh path:plugins/colorize
#	robbyrussell/oh-my-zsh path:plugins/colored-man-pages
#	robbyrussell/oh-my-zsh path:plugins/jump
#	robbyrussell/oh-my-zsh path:plugins/lol
#	robbyrussell/oh-my-zsh path:plugins/emoji
#	robbyrussell/oh-my-zsh path:plugins/thefuck
#	robbyrussell/oh-my-zsh path:plugins/dnf
#	robbyrussell/oh-my-zsh path:plugins/archlinux
#	robbyrussell/oh-my-zsh path:plugins/common-aliases
#	robbyrussell/oh-my-zsh path:plugins/docker
#	robbyrussell/oh-my-zsh path:plugins/systemd
#	robbyrussell/oh-my-zsh path:plugins/tmux
#	robbyrussell/oh-my-zsh path:plugins/yum
#	chrissicool/zsh-256color
#	# zsh-users/zsh-syntax-highlighting
#	zsh-users/zsh-autosuggestions
#	zsh-users/zsh-history-substring-search
#	zsh-users/zsh-completions
#	zdharma/fast-syntax-highlighting
#	# djui/alias-tips
#	mollifier/cd-gitroot
#	# desyncr/auto-ls
#	romkatv/powerlevel10k
#EOBUNDLES

# }}}
# }}}
# --- Aliases --- # {{{
alias sudo='sudo '
alias vim='nvim'
alias vi='nvim'
alias ix='$HOME/bin/ix'
alias pac='sudo pacman'
alias adb='$HOME/Documents/platform-tools/adb'
alias fastboot='$HOME/Documents/platform-tools/fastboot'
alias fetch='neofetch --ascii_distro arch'
alias ridiculous-name='ncmpcpp'
alias i3c='vim $HOME/.config/i3/config'
alias polycfg='vim $HOME/.config/polybar/config'
alias reload='source $ZDOTDIR/.zshrc'
alias reloadx='xrdb -load $HOME/.config/Xresources'
alias terminal-colors='$HOME/config/xres/colorschemes/dynamic-urxvt.sh'
alias :q='exit'
alias please='sudo $(fc -ln -1)'
alias jf='journalctl -f'
alias firefox='firejail firefox'
alias dotfiles='git --git-dir="${HOME}/dotfiles" --work-tree="${HOME}"'
alias dots='dotfiles'
alias da='dotfiles add'
alias dst='dotfiles status'
alias dcmsg='dotfiles commit -m'
alias dl='dotfiles pull'
alias dp='dotfiles push'
alias dirtydots='GIT_DIR="${HOME}/dotfiles" WORK_TREE="${HOME}" GIT_ADD="-u" dirtygit'
[ -f ${XDG_CONFIG_HOME:-$HOME/.config}/.aliases ] && source .aliases
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# }}}
# --- Prompt --- # {{{
# Powerlevel9k theme options
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir dir_writable vcs)
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
# }}}
