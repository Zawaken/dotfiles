# Zawaken's zshrc {{{
# vim:foldmethod=marker
case $- in
	*i*) ;;
	*) return;;
esac
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
zstyle :compinstall filename '${HOME}/.config/zsh/.zshrc'

if [ -d "${HOME}/.cache/zinit/completions" ]; then
else
  mkdir ${HOME}/.cache/zinit/completions
fi
# }}}
# --- Variables --- # {{{
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
HIST_STAMPS="dd.mm.yyyy"
ZINIT_HOME="${XDG_DATA_HOME:-${HOME:-~}/.local/share}/zinit"
bindkey -e
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$HOME/.gem/ruby/*/bin:$HOME/.local/share/gem/ruby/*/bin:$PATH
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

# Install and load zinit {{{
if test ! -f "${ZINIT_HOME}/zinit.git/zinit.zsh"; then
  print -P '%F{33} %F{220}Installing %F{33}Zinit%F{220}...%f'
  mkdir -p "${ZINIT_HOME}" \
    && chmod g-rwX "${ZINIT_HOME}"
  git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}/zinit.git" \
    && print -P '%F{33} %F{34}Installation successful!%f%b' \
    || print -P '%F{160} Cloning failed...%f%b'
fi

source "${HOME:-~}/.local/share/zinit/zinit.git/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
# }}}


# Prezto {{{
# https://github.com/sorin-ionescu/prezto/tree/master/modules
# https://github.com/sorin-ionescu/prezto/blob/master/runcoms/zpreztorc

zinit snippet PZT::modules/environment/init.zsh

zstyle ':prezto:module:terminal' auto-title 'yes'
zinit snippet PZT::modules/terminal/init.zsh

zstyle ':prezto:module:editor' dot-expansion 'yes'
zstyle ':prezto:module:editor' key-bindings 'emacs'
zstyle ':prezto:module:editor' ps-context 'yes'
zstyle ':prezto:module:prompt' managed 'yes'
zinit snippet PZTM::editor

zinit snippet PZT::modules/history/init.zsh

zinit ice wait'1' lucid
zinit snippet PZT::modules/directory/init.zsh

zinit ice wait'1' lucid
zinit snippet PZT::modules/spectrum/init.zsh

zinit snippet PZT::modules/gnu-utility/init.zsh
zstyle ':prezto:module:utility' safe-ops 'no'
zinit snippet PZTM::utility

# zinit snippet PZT::modules/completion/init.zsh
# zinit snippet PZT::modules/gpg/init.zsh

# zinit ice wait'1' lucid
# zinit snippet PZT::modules/history-substring-search/init.zsh

zstyle ':prezto:*:*' case-sensitive 'no'
zstyle ':prezto:*:*' color 'yes'

zstyle ':completion:*' special-dirs true
# }}}

# oh-my-zsh plugins {{{
zinit snippet OMZL::completion.zsh
zinit snippet OMZP::archlinux
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::command-not-found
zinit snippet OMZP::common-aliases
zinit snippet OMZP::dnf
zinit snippet OMZP::docker
zinit snippet OMZP::git
zinit snippet OMZP::git-extras
zinit snippet OMZP::kubectl
zinit snippet OMZP::systemd
zinit snippet OMZP::thefuck
zinit snippet OMZP::tmux
zinit snippet OMZP::yum
# }}}

zinit light zpm-zsh/colorize
zinit light akarzim/zsh-docker-aliases
zinit light chrissicool/zsh-256color
zinit light MichaelAquilina/zsh-you-should-use
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zdharma-continuum/zsh-diff-so-fancy
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-history-substring-search



command -v starship >/dev/null 2>&1 || (curl -fsSL https://starship.rs/install.sh | bash)
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

autoload -Uz compinit

# If zsh completion cache was updated today
if test "$(date +'%j')" != "$(date -r ${ZDOTDIR:-$HOME}/.zcompdump +'%j')"; then
  compinit
else
  # Bypass the check for rebuilding the dump file and the usual call to compaudit
  compinit -C
fi
# }}}
# --- Aliases --- # {{{
# alias sudo='nocorrect sudo '
alias vim='${EDITOR}'
alias vi='${EDITOR}'
alias reload='source $ZDOTDIR/.zshrc'
alias reloadx='xrdb -load $HOME/.config/Xresources'
alias jf='journalctl -f'
alias mon2cam="deno run --unstable -A -r -q https://raw.githubusercontent.com/ShayBox/Mon2Cam/master/src/mod.ts"
alias cliptype="xclip -selection clipboard -out | tr \\n \\r | xdotool selectwindow windowfocus type --clearmodifiers --delay 25 --window %@ --file -"
alias yay="paru "
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
# eval "$(starship init zsh)"

zinit ice as'command' from'gh-r' \
  atclone'./starship init zsh > init.zsh; ./starship completions zsh > _starship' \
  atpull'%atclone' src'init.zsh'
zinit light starship/starship

source <(kubectl completion zsh)
if [[ -f $HOME/.aliases ]]; then
  source $HOME/.aliases
fi
# }}}
