" --- Zawaken's vimrc --- " {{{
" vim:foldmethod=marker
" }}}
" --- General --- " {{{
" --- Oni --- " {{{
if exists('g:gui_oni')
  set noswapfile
  set smartcase
  set mouse=a
  set noshowmode
  set noruler
  set laststatus=0
  set noshowcmd
endif
" }}}

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
let mapleader=','
set nocompatible
filetype plugin on
syntax on
set encoding=utf-8
set number
set relativenumber
let g:colorscheme = 'one'
set listchars=tab:▸\ ,eol:¬
set list

" Splits navigation.
set splitbelow
set splitright
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" coc ignore startup message
let g:coc_disable_startup_warning = 1

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

" C-T for new tab, currently only newtab works
nnoremap <C-t> :tabnew<cr>
nnoremap <C-S-tab> :tabprevious<CR>
nnoremap <C-tab> :tabnext<CR>
inoremap <C-S-tab> <Esc>:tabprevious<CR>i
inoremap <C-tab>   <Esc>:tabnext<CR>i
inoremap <C-t> <Esc>:tabnew<CR>

nmap <leader>c :noh<CR>
nmap <leader>t :tabnew<CR>
nmap <leader>j :tabprevious<CR>
nmap <leader>k :tabnext<CR>
vnoremap K xkP`[V`]
vnoremap J xp`[V`]
vnoremap L >gv
vnoremap H <gv
" }}}
" --- Plugins --- " {{{
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-github-dashboard'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'tpope/vim-commentary'
Plug 'junegunn/goyo.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'vimwiki/vimwiki'
Plug 'Raimondi/delimitMate'
Plug 'terryma/vim-multiple-cursors'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'dstein64/vim-startuptime'
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': { -> coc#util#install() }}

" Colorschemes
Plug 'tomasr/molokai'
Plug 'AlessandroYorba/Despacio'
Plug 'nightsense/cosmic_latte'
Plug 'nightsense/snow'
Plug 'nightsense/stellarized'
Plug 'junegunn/seoul256.vim'
Plug 'sjl/badwolf'
Plug 'xero/sourcerer.vim'
Plug 'AlessandroYorba/Sierra'
Plug 'mhartington/oceanic-next'
Plug 'rakr/vim-one'
Plug 'liuchengxu/space-vim-dark'
Plug 'jacoborus/tender.vim'
Plug 'joshdick/onedark.vim'

" why
" :source vimty.vim
Plug 'dixonary/vimty'
Plug 'Kody-Quintana/bspwm_border_color'
Plug 'hugolgst/vimsence'

"Syntax highlighting/autocompletion
" Plug 'scrooloose/syntastic'
Plug 'rodjek/vim-puppet'
Plug 'chr4/nginx.vim'
Plug 'ObserverOfTime/coloresque.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'dense-analysis/ale'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'ap/vim-css-color'
"if has('nvim')
"  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"else
"  Plug 'Shougo/deoplete.nvim'
"  Plug 'roxma/nvim-yarp'
"  Plug 'roxma/vim-hug-neovim-rpc'
"endif
"let g:deoplete#enable_at_startup = 1

call plug#end()

" NERDTree config
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
map <C-o> :NERDTreeToggle<CR>
let g:NERDTreeGitStatusWithFlags = 1

" Used by coc
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction
set hidden

inoremap <silent><expr> <c-space> coc#refresh() " Use <c-space> to trigger completion.

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction
" }}}
" --- Filetype Dependent config --- " {{{
if has("autocmd")
	" Enable file type detection
	filetype on

	" Syntax of these languages is fussy over tabs Vs spaces
	autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
	autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

	" Customisations based on house-style (arbitrary)
	autocmd BufEnter,BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
	autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab
	autocmd FileType php setlocal ts=4 sts=4 sw=4 expandtab
	autocmd FileType haskell setlocal ts=4 sts=4 sw=4 expandtab
	autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
	autocmd FileType html nnoremap <F5> :!open -a Safari %<CR><CR>
	autocmd FileType xml setlocal ts=2 sts=2 sw=2 expandtab
	autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
	autocmd FileType scss setlocal ts=2 sts=2 sw=2 expandtab
	autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab
	autocmd FileType rb setlocal ts=2 sts=2 sw=2 expandtab
	autocmd BufRead,BufNewFile *.erb set filetype=eruby.html
	autocmd FileType eruby.html setlocal ts=2 sts=2 sw=2 expandtab
	autocmd FileType sh setlocal ts=2 sts=2 sw=2 expandtab
	autocmd FileType vim setlocal ts=4 sts=4 sw=4 expandtab
	au BufRead,BufNewFile * setfiletype txt

	" Treat .rss files as XML
	autocmd BufNewFile,BufRead *.rss setfiletype xml
endif
" }}}
" --- aesthetics --- " {{{
if (has('termguicolors'))
  set termguicolors
endif

" Enable 256-colors, has to be set before colorscheme
set t_Co=256
set t_AB=^[[48;5;%dm
set t_AF=^[[38;5;%dm

" Colorscheme
set background=dark
execute "colorscheme " . g:colorscheme

highlight Comment cterm=italic
highlight Normal     ctermbg=NONE guibg=NONE
highlight LineNr     ctermbg=NONE guibg=NONE
highlight SignColumn ctermbg=NONE guibg=NONE

" Background
set background=dark

" gruvbox
let g:gruvbox_italic = 1

" airline
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_powerline_fonts = 1

" Font
set guifont=Source\ Code\ Pro\ for\ Powerline

" transparency + italic text on comments
hi Normal guibg=NONE ctermbg=NONE
hi Comment cterm=italic

" }}}
" --- Functions --- " {{{
" Toggle line numbers
function! ToggleNumbers()
	if &number || &relativenumber
		call EnterInsert()
		set nonumber
		set norelativenumber
	else
		call LeaveInsert()
	endif
endfunction
nmap <silent> <leader>n :call ToggleNumbers()<CR>

function! EnterInsert()
	GitGutterDisable
	set cursorline
	set norelativenumber
	set number
endfunction
function! LeaveInsert()
	GitGutterEnable
	set nocursorline
	set relativenumber
	set number
endfunction
" autocmd InsertEnter * call EnterInsert()
" autocmd FocusLost * call EnterInsert()
" autocmd InsertLeave * call LeaveInsert()
" autocmd FocusGained * call LeaveInsert()
autocmd VimEnter * call LeaveInsert()

" Fancy folding
function! FoldText()
	set fillchars=fold:\ "
	let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
	let lines_count = v:foldend - v:foldstart + 1
	let lines_count_text = '⊲ ' . printf("%10s", lines_count . ' lines') . ' ⊳'
	let foldchar = matchstr(&fillchars, 'fold:\zs.')
	let foldtextstart = strpart('⨾' . repeat(foldchar, v:foldlevel-1) . line, 0, (winwidth(0)*2)/3)
	"let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
	let foldtextend = lines_count_text . repeat(foldchar, 8)
	let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
	return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
set foldtext=FoldText()

" }}}
