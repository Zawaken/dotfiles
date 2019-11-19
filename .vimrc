" --- Zawaken's vimrc --- " {{{
" vim:foldmethod=marker
" }}}
" --- General --- " {{{
inoremap jw <Esc>
inoremap wj <Esc>
inoremap asd <Esc>
let mapleader=','
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

" C-T for new tab, currently only newtab works
nnoremap <C-t> :tabnew<cr>
nnoremap <C-S-tab> :tabprevious<CR>
nnoremap <C-tab> :tabnext<CR>
inoremap <C-S-tab> <Esc>:tabprevious<CR>i
inoremap <C-tab>   <Esc>:tabnext<CR>i
inoremap <C-t> <Esc>:tabnew<CR>

" For normal mode when in terminals
inoremap jw <Esc>
inoremap wj <Esc>
inoremap asd <Esc>


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
Plug 'neoclide/coc.nvim'


" Colorschemes
Plug 'morhetz/gruvbox'
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

" why
" :source vimty.vim
Plug 'dixonary/vimty'

"Syntax highlighting/autocompletion
Plug 'scrooloose/syntastic'
Plug 'rodjek/vim-puppet'
Plug 'chr4/nginx.vim'
Plug 'ObserverOfTime/coloresque.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'dense-analysis/ale'
Plug 'PotatoesMaster/i3-vim-syntax'
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
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
map <C-o> :NERDTreeToggle<CR>

" coc
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR><Paste>
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
  au BufRead,BufNewFile * setfiletype txt

  " Treat .rss files as XML
  autocmd BufNewFile,BufRead *.rss setfiletype xml
endif
" }}}
" --- aesthetics --- " {{{
" Colorscheme
colorscheme gruvbox
" colorscheme sierra
" colorscheme space-vim-dark

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
