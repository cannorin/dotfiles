"--------------
"   Base
"--------------

runtime! debian.vim
if has("syntax")
    syntax on
endif
set autoindent
set nocompatible
set whichwrap=b,s,h,l,<,>,[,]

"--------------
"   View
"--------------

colorscheme desert
set title
set display=uhex
set number
set shortmess+=I
set showcmd
set cmdheight=1
set scrolloff=2
set laststatus=2
highlight StatusLine term=bold cterm=bold ctermfg=black ctermbg=white
set textwidth=0
set wrap
set fileencodings=utf-8,euc-jp,iso-2022-jp,utf-8,cp932
if &encoding == 'utf-8'
    set ambiwidth=double
endif
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/
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
set showmatch
set matchtime=4
set backspace=indent,eol,start
set wildmenu
set cindent
set undolevels=1000
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set writeany 

"--------------
"  Search
"--------------

set history=100
set ignorecase
set wrapscan
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
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
    execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ

"--------------
"    Dev
"--------------

autocmd FileType cs :compiler mcs
autocmd FileType c :compiler clang
autocmd FileType cpp :compiler g++
autocmd FileType hs :compiler ghc
map <F5>  :!mcs %<CR>
map <F6>  :!clang %<CR>
map <F7>  :!g++ %<CR>
map <F8>  :!ghc %<CR>
filetype plugin on
set omnifunc=syntaxcomplete#Complete

"--------------
"  NeoBundle
"--------------

if 0 | endif

filetype off

if has('vim_starting')
    if &compatible
        set nocompatible               " Be iMproved
    endif

    set runtimepath+=~/.vim/bundle/neobundle.vim
endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle "kongo2002/fsharp-vim"

call neobundle#end()

filetype plugin indent on     " required!
filetype indent on
syntax on

NeoBundleCheck

let g:make = 'gmake'
if system('uname -o') =~ '^GNU/'
    let g:make = 'make'
endif

