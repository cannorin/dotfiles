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

set completeopt+=noinsert,noselect
set completeopt-=preview

"--------------
"  Mapping
"--------------

noremap <C-J> <C-E>
noremap <C-K> <C-Y>

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

  Plug 'tomasiser/vim-code-dark'
  Plug 'vim-airline/vim-airline'

  Plug 'neovim/nvim-lspconfig'

  if $IONIDE_DEBUG == 1
    Plug '~/codes/Ionide-vim'
  else
    Plug 'ionide/Ionide-vim'
  endif

  if has('nvim')
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/cmp-nvim-lsp', { 'branch': 'main' }
    Plug 'hrsh7th/cmp-buffer', { 'branch': 'main' }
    Plug 'hrsh7th/cmp-path', { 'branch': 'main' }
    Plug 'hrsh7th/cmp-cmdline', { 'branch': 'main' }
    Plug 'hrsh7th/nvim-cmp', { 'branch': 'main' }
    Plug 'hrsh7th/cmp-vsnip', { 'branch': 'main' }
    Plug 'hrsh7th/vim-vsnip'
    Plug 'antoinemadec/FixCursorHold.nvim'
    Plug 'folke/trouble.nvim'
  else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
    Plug 'deoplete-plugins/deoplete-lsp'
  endif

  Plug 'cohama/lexima.vim'

  Plug 'lambdalisue/fern.vim', { 'branch': 'main' }

  call plug#end()

  colorscheme codedark

  call s:airline()
  call s:fern()
  call s:trouble()
  call s:language_settings()
  call s:autocompletion()
  call s:nvim_lsp()
endfunction

function! s:airline()
  let g:airline_theme = 'codedark'
  let g:airline#extensions#default#layout = [
    \ [ 'a', 'b', 'c' ],
    \ [ 'x', 'y', 'z' ]
    \ ]
  let g:airline_section_c = '%f %M'
  let g:airline_section_z = get(g:, 'airline_linecolumn_prefix', '').'%3l:%-2v'
  let g:airline#extensions#hunks#non_zero_only = 1 
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#fnamemod = ':t'
  let g:airline#extensions#tabline#show_buffers = 0
  let g:airline#extensions#tabline#show_splits = 0
  let g:airline#extensions#tabline#show_tab_nr = 1
  let g:airline#extensions#tabline#show_tab_count = 0
  let g:airline#extensions#tabline#tab_nr_type = 1
  let g:airline#extensions#tabline#show_close_button = 0
endfunction

function! s:fern()
  let g:fern#disable_default_mappings = 1

  nnoremap <silent> <C-E> :Fern . -reveal=% -drawer -toggle -right<CR>
  nnoremap <Plug>(fern-close-drawer) :<C-u>FernDo close -drawer -right -stay<CR>

  function! s:init_fern() abort
    nmap <buffer> . <Plug>(fern-action-hidden:toggle)
    nmap <buffer><expr>
      \ <Plug>(fern-smart-open)
      \ fern#smart#leaf(
      \   "<Plug>(fern-action-open:tabedit)",
      \   "<Plug>(fern-action-expand)",
      \   "<Plug>(fern-action-collapse)",
      \ )
    nmap <buffer><nowait> <CR> <Plug>(fern-smart-open)
    nmap <buffer><silent> <Plug>(fern-action-open-and-close)
        \ <Plug>(fern-action-open:edit)
        \ <Plug>(fern-close-drawer)
    nmap <buffer> e <Plug>(fern-action-open-and-close)
    nmap <buffer> c <Plug>(fern-action-copy)
    nmap <buffer> d <Plug>(fern-action-diff:tabedit:vert)
    nmap <buffer> g <Plug>(fern-action-grep)
    nmap <buffer> m <Plug>(fern-action-mark:toggle)
    nmap <buffer> r <Plug>(fern-action-rename)
    nmap <buffer> <C-r> <Plug>(fern-action-reload)
    nmap <buffer> q :<C-u>quit<CR>
  endfunction

  augroup fern-custom
    autocmd! *
    autocmd FileType fern call s:init_fern()
  augroup END
endfunction

function! s:trouble()
  nnoremap <C-w> <cmd>TroubleToggle<cr>
lua << EOF
  require("trouble").setup {
    icons = false,
    fold_open = "v", -- icon used for open folds
    fold_closed = ">", -- icon used for closed folds
    indent_lines = false, -- add an indent guide below the fold icons
    signs = {
        -- icons / text used for a diagnostic
        error = "X",
        warning = "!",
        hint = "?",
        information = "i"
    },
    use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
  }
EOF
endfunction

function! s:autocompletion()
  if has('nvim')
lua << EOF
      local cmp = require'cmp'

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = {
          ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
          ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
          ['<M-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
          ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
          ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = cmp.config.sources({ { name = 'nvim_lsp' }, { name = 'vsnip' }, { name = 'buffer' } })
      })

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline('/', { sources = { { name = 'buffer' } } })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', { sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }) })
EOF
  else
    let g:deoplete#enable_at_startup = 1
  endif
endfunction

function! s:nvim_lsp()
lua << EOF
  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end 
  
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  local setup = function(server)
    server.setup {
      autostart = true,
      on_attach = on_attach,
      flags = {
        debounce_text_changes = 150,
      },
      capabilities = capabilities
    }
  end

  local lspconfig = require('lspconfig')
  setup(lspconfig.ocamllsp)
  setup(lspconfig.ccls)
  setup(require('ionide'))
  
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
   vim.lsp.diagnostic.on_publish_diagnostics, {
     virtual_text = false, underline = true
   }
  )
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, { focusable = false }
  )
EOF
endfunction

function! s:language_settings()
  if has('nvim') && exists('*nvim_open_win')
    set updatetime=1000
    augroup FSharpShowTooltip
      autocmd!
      autocmd CursorHold *.fs,*.fsi,*.fsx call fsharp#showTooltip()
      autocmd CompleteDonePre *.fs call s:test()
    augroup END
  endif

  let g:fsharp#exclude_project_directories = ['paket-files']
  let g:fsharp#linter = 1
  let g:fsharp#unused_opens_analyzer = 1
  let g:fsharp#unused_declarations_analyzer = 1
  let g:fsharp#enable_reference_code_lens = 0
  " let g:fsharp#line_lens = { 'enabled': 'never', 'prefix': '' }
  let g:fsharp#show_signature_on_cursor_move = 0
  let g:fsharp#lsp_auto_setup = 0
endfunction

call s:setup()
