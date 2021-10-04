" --- Zawaken's vimrc --- " {{{
" vim:foldmethod=marker
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
let mapleader=','
let maplocalleader=','
" }}}
" --- Plugins --- " {{{
" Plug installation {{{
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}

let g:colorscheme = 'one'
set nocompatible
call plug#begin('~/.vim/plugged')
" General {{{
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim' " {{{
nmap <silent> <leader>f :FZF<CR>
let g:fzf_layout = {
 \ 'window': 'new | wincmd J | resize 1 | call animate#window_percent_height(0.5)'
\ }
" }}}
if has('nvim-0.5')
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
endif
Plug 'tpope/vim-vinegar' " netrw {{{
  "let loaded_netrwPlugin = 0 " netrw version, 0 to disable
  let g:netrw_banner = 0
  let g:netrw_liststyle = 3 " 1 or 3
  let g:netrw_browse_split = 4 " 1
  let g:netrw_altv = 1
  let g:netrw_winsize = 25
  let g:netrw_keepdir = 0
  let g:netrw_sort_options = 'i'
  let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+,\(^\|\s\s\)ntuser\.\S\+'
  let g:netrw_sort_sequence = '[\/]$,*'
  let g:netrw_list_hide = '.*.swp$,
                        \ *.pyc$,
                        \ *.log$,
                        \ *.o$,
                        \ *.xmi$,
                        \ *.swp$,
                        \ *.bak$,
                        \ *.pyc$,
                        \ *.class$,
                        \ *.jar$,
                        \ *.war$,
                        \ *.png$,
                        \ *.jpg$,
                        \ *.mkv$,
                        \ *.mp4$,
                        \ *.mp3$,
                        \ *node_modules*,
                        \ *__pycache__*'

  augroup ProjectDrawer | autocmd!
    "autocmd VimEnter * silent Vexplore | wincmd p
    "autocmd FileType netrw set nolist
    " No argument was specified
    autocmd VimEnter * if !argc() && !exists("s:std_in") | silent Lexplore | wincmd p | endif
    autocmd StdinReadPre * let s:std_in=1
    " Specified argument is a directory
    autocmd VimEnter * if isdirectory(expand('<afile>')) && !exists("s:std_in") | silent vnew | endif
    " Only window left
    autocmd BufEnter * if (winnr("$") == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw") | q | endif
    autocmd FileType netrw setlocal bufhidden=wipe
    autocmd FileType netrw vertical resize 25
    autocmd FileType netrw nnoremap <buffer> q :q<CR>
  augroup END

  "map <silent> <C-n> :NetrwToggle <bar> wincmd p<CR>
  map <silent> <C-o> :Lexplore<CR>
" }}}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'lervag/wiki.vim'
Plug 'Raimondi/delimitMate'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes' " {{{
" airline
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_powerline_fonts = 1
" }}}
Plug 'airblade/vim-gitgutter'
Plug 'dstein64/vim-startuptime'
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': { -> coc#util#install() }} " {{{
" Used by coc
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-vetur',
  \ 'coc-css',
  \ 'coc-yaml',
  \ 'coc-highlight',
  \ 'coc-markdownlint',
  \ 'coc-emoji',
  \ 'coc-sh',
  \ 'coc-pyright',
  \ 'coc-tsserver',
  \ ]
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
" coc ignore startup message
let g:coc_disable_startup_warning = 1
" }}}
" }}}
" Colorschemes {{{
Plug 'rakr/vim-one'
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
Plug 'liuchengxu/space-vim-dark'
Plug 'jacoborus/tender.vim'
Plug 'joshdick/onedark.vim'
" }}}
"Syntax highlighting/autocompletion {{{
Plug 'rodjek/vim-puppet'
Plug 'chr4/nginx.vim', { 'for': 'nginx'}
Plug 'kovetskiy/sxhkd-vim', { 'for': 'sxhkdrc'}
Plug 'ObserverOfTime/coloresque.vim'
Plug 'ekalinin/Dockerfile.vim', { 'for': 'Dockerfile'}
" }}}
" useless {{{
Plug 'hugolgst/vimsence'
" }}}

call plug#end()

" }}}
" --- General --- " {{{

filetype plugin on
syntax on
set encoding=utf-8
set number
set relativenumber
set listchars=tab:▸\ ,eol:¬
set list

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
	autocmd FileType typescript setlocal ts=4 sts=4 sw=4 expandtab
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

" gruvbox
let g:gruvbox_italic = 1

" Font
set guifont=Source\ Code\ Pro\ for\ Powerline

" transparency + italic text on comments
hi Normal guibg=NONE ctermbg=NONE
hi Comment cterm=italic

" }}}
" --- Functions --- " {{{
" Toggle line numbers {{{
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
    set list!
endfunction
function! LeaveInsert()
	GitGutterEnable
	set nocursorline
	set relativenumber
	set number
    set list
endfunction

" autocmd InsertEnter * call EnterInsert()
" autocmd FocusLost * call EnterInsert()
" autocmd InsertLeave * call LeaveInsert()
" autocmd FocusGained * call LeaveInsert()
autocmd VimEnter * call LeaveInsert()
" }}}
" Fancy folding {{{
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
" Automatically close tab/vim if the only open buffers are NERDTree and/or Calendar {{{
function! TabQuit()
  " https://vim.fandom.com/wiki/Tabclose_instead_of_quit-all
  try
    if tabpagenr('$') > 1
      silent exec 'tabclose'
    else
      silent exec 'qa'
    endif
  catch
    echohl ErrorMsg | echo v:exception | echohl NONE
  endtry
endfunction
function! NerdTreeEnabled()
  return exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1
endfunction
function! CalendarEnabled()
  return bufwinnr("Calendar") != -1
endfunction
function! ShouldClose()
  return (winnr("$") == 1 && (NerdTreeEnabled() || CalendarEnabled())) || (winnr("$") == 2 && (NerdTreeEnabled() && CalendarEnabled()))
endfunction
autocmd BufEnter * if ShouldClose() | call TabQuit() | endif
" }}}
" }}}
