"--------------
"   Base
"--------------

set nocompatible
set whichwrap=b,s,h,l,<,>,[,]

if exists('g:gui_oni')
  set shell=bash
  set shellcmdflag=-c
  set shellquote=
  set shellxescape=
  set shellxquote="
else
  runtime! debian.vim
endif

if has("syntax")
  syntax on
endif
filetype plugin on

set autoindent

"--------------
"   View
"--------------

set title
set display=uhex
set number
set scrolloff=2
set shortmess+=I

if exists('g:gui_oni')
  set noswapfile
  set noshowmode
  set noruler
  set laststatus=0
  set noshowcmd
else
  set showcmd
  set cmdheight=1
  set laststatus=2
  highlight StatusLine term=bold cterm=bold ctermfg=black ctermbg=white
endif

set textwidth=0
set wrap
set fileencodings=utf-8,euc-jp,iso-2022-jp,utf-8,cp932
if &encoding == 'utf-8'
    set ambiwidth=double
endif
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/
highlight Tab cterm=underline ctermfg=lightgreen guibg=darkgray
match Tab /	/
set cursorline
augroup cch
    autocmd! cch
    autocmd WinLeave * set nocursorline
    autocmd WinEnter,BufRead * set cursorline
augroup END
augroup InsertHook
    autocmd!
    autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
    autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
augroup END

:hi clear CursorLine
:hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black


"--------------
"    Edit
"--------------

let putline_tw = 30
inoremap <Leader>line <ESC>:call <SID>PutLine(putline_tw)<CR>A
function! s:PutLine(len)
    let plen = a:len - strlen(getline('.'))
    if (plen > 0)
        execute 'normal ' plen . 'A-'
    endif
endfunction
set mouse=a
set clipboard&
set clipboard^=unnamedplus

set showmatch
set matchtime=4
set backspace=indent,eol,start
set wildmenu
set cindent
set undolevels=1000
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
au FileType c setl sw=2 ts=2 sts=2
au FileType cs setl sw=4 ts=4 sts=4
au FileType fsharp setl sw=2 ts=2 sts=2
au FileType nml setl sw=2 ts=2 sts=2
au FileType make set noexpandtab sw=4 ts=4 sts=4
set writeany

"--------------
"  Search
"--------------

set history=100
set ignorecase
set wrapscan
set incsearch
vnoremap * "zy:let @/ = @z<CR>n

" Anywhere SID.
function! s:SID_PREFIX()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
    let s = ''
    for i in range(1, tabpagenr('$'))
        let bufnrs = tabpagebuflist(i)
        let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
        let no = i  " display 0-origin tabpagenr.
        let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
        let title = fnamemodify(bufname(bufnr), ':t')
        let title = '[' . title . ']'
        let s .= '%'.i.'T'
        let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
        let s .= no . ':' . title
        let s .= mod
        let s .= '%#TabLineFill# '
    endfor
    let s .= '%#TabLineFill#%T%=%#TabLine#'
    return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2

nnoremap    [Tag]   <Nop>
nmap    t [Tag]

for n in range(1, 9)
    execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

nnoremap <silent> [Tag]0 :tablast<CR>
map <silent> [Tag]c :tablast <bar> tabnew<CR>
map <silent> [Tag]x :tabclose<CR>
map <silent> [Tag]l :tabnext<CR>
map <silent> [Tag]L :+tabmove<CR>
map <silent> [Tag]h :tabprevious<CR>
map <silent> [Tag]H :-tabmove<CR>

"--------------
"  Plugins
"--------------

function! s:setup()
  if !exists('g:gui_oni')
  \ && (empty(glob('~/.vim/autoload/plug.vim'))
  \ ||  empty(glob('~/.local/share/nvim/site/autoload/plug.vim')))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
  call plug#begin('~/.vim/plugged')

  if $LSPCONFIG == 1
    Plug 'neovim/nvim-lspconfig'
  endif

  Plug 'hrsh7th/nvim-compe'

  if $IONIDE_DEBUG == 1
    Plug '~/Documents/codes/Ionide-vim'
  else
    Plug 'ionide/Ionide-vim', {
        \ 'do':  'make fsautocomplete',
        \}
  endif

  Plug 'cohama/lexima.vim'

  call plug#end()
endfunction

function! s:languageclient()
  if has('nvim') && exists('*nvim_open_win')
    set updatetime=1000
    augroup FSharpShowTooltip
      autocmd!
      autocmd CursorHold *.fs,*.fsi,*.fsx call fsharp#showTooltip()
    augroup END
  endif

  let g:fsharp#exclude_project_directories = ['paket-files']
  let g:fsharp#linter = 0
  let g:fsharp#enable_reference_code_lens = 1
  let g:fsharp#line_lens = { 'enabled': 'never', 'prefix': '' }

  let g:fsharp#fsharp_interactive_command = "fsharpi"
  let g:fsharp#use_sdk_scripts = 0
  " let g:fsharp#fsi_extra_parameters = ['--langversion:preview']
endfunction

call s:setup()
call s:languageclient()


