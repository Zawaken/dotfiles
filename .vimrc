if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set guifont=Source\ Code\ Pro\ for\ Powerline "make sure to escape the spaces in the name properly

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif

let g:airline_powerline_fonts = 1

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'scrooloose/nerdtree'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'tyru/caw.vim'
Plug 'tpope/vim-commentary'
Plug 'morhetz/gruvbox'
call plug#end()

" Some basics:
	set nocompatible
	filetype plugin on
	syntax on
	set encoding=utf-8
	set number
	set relativenumber

" Splits navigation.
	set splitbelow
	set splitright
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

" Smart casing
	set smartcase
	set ignorecase

" File interpreting
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}

" Get line, word and character counts with F3:
	map <F3> :!wc <C-R>%<CR>

" Spell-check set to F6:
	map <F6> :setlocal spell! spelllang=en_us,es<CR>

" Copy selected text to system clipboard (requires gvim installed):
	vnoremap <C-c> "*Y :let @+=@*<CR>
	map <C-p> "+P

" Enable autocompletion:
	set wildmode=longest,list,full
	set wildmenu

" Automatically deletes all trailing whitespace on save.
	autocmd BufWritePre * %s/\s\+$//e

" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" C-T for new tab
	nnoremap <C-t> :tabnew<cr>

" For normal mode when in terminals
	inoremap jw <Esc>
	inoremap wj <Esc>

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif<Paste>

vnoremap K xkP`[V`]
vnoremap J xp`[V`]
vnoremap L >gv
vnoremap H <gv
