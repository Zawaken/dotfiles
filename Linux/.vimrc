call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

call plug#end()

set guifont=Source\ Code\ Pro\ for\ Powerline "make sure to escape the spaces in the name properly

let g:airline_powerline_fonts = 1

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

vnoremap K xkP`[V`]
vnoremap J xp`[V`]
vnoremap L >gv
vnoremap H <gv
