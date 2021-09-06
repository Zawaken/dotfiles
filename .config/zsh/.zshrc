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
export STARSHIP_CONFIG=$HOME/.config/starship.toml
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [ ! -S ~/.ssh/ssh_auth_sock ]; then
  eval `ssh-agent`
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l > /dev/null || ssh-add
# }}}
# --- Functions --- # {{{
# pastor pastebin {{{
pastor() {
	[[ "$1" ]] || { echo "Error: Missing file" >&2; return 1}
	curl -F "a=@$1" "${2:-https://p.btrfs.no}"
}
# }}}
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
	#antigen theme miloshadzic

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
command -v starship >/dev/null 2>&1 || (curl -fsSL https://starship.rs/install.sh | bash)
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
# }}}
# --- Aliases --- # {{{
alias sudo='sudo '
alias vim='${EDITOR}'
alias vi='${EDITOR}'
alias reload='source $ZDOTDIR/.zshrc'
alias reloadx='xrdb -load $HOME/.config/Xresources'
alias jf='journalctl -f'
alias mon2cam="deno run --unstable -A -r -q https://raw.githubusercontent.com/ShayBox/Mon2Cam/master/src/mod.ts"
alias cliptype="xclip -selection clipboard -out | tr \\n \\r | xdotool selectwindow windowfocus type --clearmodifiers --delay 25 --window %@ --file -"
[ -f ${XDG_CONFIG_HOME:-$HOME/.config}/.aliases ] && source .aliases
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# }}}
# --- dotfiles --- # {{{
export DOT_DIR="${HOME}/.config/dotfiles/.git"
export DOT_TREE="${HOME}"
export DOTBARE_DIR="${DOT_DIR}"
export DOTBARE_TREE="${DOT_TREE}"

alias dotfiles='git --git-dir="${HOME}/dotfiles" --work-tree="${HOME}"'
alias dots='dotfiles'
alias dirtydots='GIT_DIR="${HOME}/dotfiles" WORK_TREE="${HOME}" GIT_ADD="-u" dirtygit'
# dotfile short git aliases # {{{
alias da='dotfiles add'
alias dst='dotfiles status'
alias dcmsg='dotfiles commit -m'
alias dl='dotfiles pull'
alias dp='dotfiles push'
# }}}
#dotfiles () {
#  if test "${#}" -eq "0"; then
#    dotfiles status
#    return 0
#  fi
#  #for var in "${@}"; do
#  #  if test "${var}" = "."; then
#  #    printf "\'.\' argument disabled by dotfiles git wrapper."
#  #    return 1
#  #  fi
#  #done
#  git --git-dir="${DOT_DIR}" --work-tree="${DOT_TREE}" "${@}"
#}
#}}}
# --- Prompt --- # {{{
# Powerlevel9k theme options
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir dir_writable vcs)
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
# }}}
# --- Sourcing --- # {{{
eval "$(starship init zsh)"
# }}}
