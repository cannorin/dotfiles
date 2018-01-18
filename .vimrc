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
filetype plugin on 

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
set showmatch
set matchtime=4
set backspace=indent,eol,start
set wildmenu
set cindent
set undolevels=1000
set tabstop=2
set softtabstop=2
set shiftwidth=2
au FileType cs setl sw=4 ts=4 sts=4
au FileType fsharp setl sw=2 ts=2 sts=2
au FileType nml setl sw=2 ts=2 sts=2
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
set showtabline=2

nnoremap    [Tag]   <Nop>
nmap    t [Tag]

for n in range(1, 9)
    execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

map <silent> [Tag]c :tablast <bar> tabnew<CR>
map <silent> [Tag]x :tabclose<CR>
map <silent> [Tag]n :tabnext<CR>
map <silent> [Tag]p :tabprevious<CR>

"--------------
"  Plugins
"--------------

function! s:setup()
    fun! EnsureVamIsOnDisk(plugin_root_dir)
      let vam_autoload_dir = a:plugin_root_dir.'/vim-addon-manager/autoload'
      if isdirectory(vam_autoload_dir)
        return 1
      else
        if 1 == confirm("Clone VAM into ".a:plugin_root_dir."?","&Y\n&N")
          call confirm("Remind yourself that most plugins ship with ".
                      \"documentation (README*, doc/*.txt). It is your ".
                      \"first source of knowledge. If you can't find ".
                      \"the info you're looking for in reasonable ".
                      \"time ask maintainers to improve documentation")
          call mkdir(a:plugin_root_dir, 'p')
          execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '.
                      \       shellescape(a:plugin_root_dir, 1).'/vim-addon-manager'
          exec 'helptags '.fnameescape(a:plugin_root_dir.'/vim-addon-manager/doc')
        endif
        return isdirectory(vam_autoload_dir)
      endif
    endfun

    fun! SetupVAM()
      " Set advanced options like this:
      " let g:vim_addon_manager = {}
      " let g:vim_addon_manager.key = value
      "     Pipe all output into a buffer which gets written to disk
      " let g:vim_addon_manager.log_to_buf =1

      " Example: drop git sources unless git is in PATH. Same plugins can
      " be installed from www.vim.org. Lookup MergeSources to get more control
      " let g:vim_addon_manager.drop_git_sources = !executable('git')
      " let g:vim_addon_manager.debug_activation = 1

      " VAM install location:
      let c = get(g:, 'vim_addon_manager', {})
      let g:vim_addon_manager = c
      let c.plugin_root_dir = expand('$HOME/.vim/vim-addons', 1)
      if !EnsureVamIsOnDisk(c.plugin_root_dir)
        echohl ErrorMsg | echomsg "No VAM found!" | echohl NONE
        return
      endif
      let &rtp.=(empty(&rtp)?'':',').c.plugin_root_dir.'/vim-addon-manager'

      " Tell VAM which plugins to fetch & load:
      call vam#ActivateAddons(['github:OmniSharp/omnisharp-vim', 'github:tpope/vim-dispatch', 'github:scrooloose/syntastic', 'github:Shougo/unite.vim', 'github:Shougo/neocomplete.vim', 'github:ervandew/supertab', 'github:tpope/vim-pathogen', 'github:fsharp/vim-fsharp'], {'auto_install' : 0})
      " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})
      " Also See "plugins-per-line" below

      " Addons are put into plugin_root_dir/plugin-name directory
      " unless those directories exist. Then they are activated.
      " Activating means adding addon dirs to rtp and do some additional
      " magic

      " How to find addon names?
      " - look up source from pool
      " - (<c-x><c-p> complete plugin names):
      " You can use name rewritings to point to sources:
      "    ..ActivateAddons(["github:foo", .. => github://foo/vim-addon-foo
      "    ..ActivateAddons(["github:user/repo", .. => github://user/repo
      " Also see section "2.2. names of addons and addon sources" in VAM's documentation
    endfun
    call SetupVAM()
    " experimental [E1]: load plugins lazily depending on filetype, See
    " NOTES
    " experimental [E2]: run after gui has been started (gvim) [3]
    " option1:  au VimEnter * call SetupVAM()
    " option2:  au GUIEnter * call SetupVAM()
    " See BUGS sections below [*]
    " Vim 7.0 users see BUGS section [3]
endfunction

function! s:syntastic()
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*

  " let g:syntastic_always_populate_loc_list = 1
  " let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0
  let g:syntastic_fsharp_checkers = ['syntax']
endfunction

function! s:omnisharp()
    "This is the default value, setting it isn't actually necessary
    let g:OmniSharp_host = "http://localhost:2000"

    "Set the type lookup function to use the preview window instead of the status line
    "let g:OmniSharp_typeLookupInPreview = 1

    "Timeout in seconds to wait for a response from the server
    let g:OmniSharp_timeout = 1

    "Showmatch significantly slows down omnicomplete
    "when the first match contains parentheses.
    set noshowmatch

    "Super tab settings - uncomment the next 4 lines
    let g:SuperTabDefaultCompletionType = 'context'
    let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
    let g:SuperTabDefaultCompletionTypeDiscovery = ["&omnifunc:<c-x><c-o>","&completefunc:<c-x><c-n>"]
    let g:SuperTabClosePreviewOnPopupClose = 1

    "don't autoselect first item in omnicomplete, show if only one item (for preview)
    "remove preview if you don't want to see any documentation whatsoever.
    set completeopt=longest,menuone
    " Fetch full documentation during omnicomplete requests.
    " There is a performance penalty with this (especially on Mono)
    " By default, only Type/Method signatures are fetched. Full documentation can still be fetched when
    " you need it with the :OmniSharpDocumentation command.
    " let g:omnicomplete_fetch_documentation=1

    "Move the preview window (code documentation) to the bottom of the screen, so it doesn't move the code!
    "You might also want to look at the echodoc plugin
    set splitbelow

    " Get Code Issues and syntax errors
    let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
    " If you are using the omnisharp-roslyn backend, use the following
    " let g:syntastic_cs_checkers = ['code_checker']
    augroup omnisharp_commands
        autocmd!

        "Set autocomplete function to OmniSharp (if not using YouCompleteMe completion plugin)
        autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

        " Synchronous build (blocks Vim)
        "autocmd FileType cs nnoremap <F5> :wa!<cr>:OmniSharpBuild<cr>
        " Builds can also run asynchronously with vim-dispatch installed
        autocmd FileType cs nnoremap <leader>b :wa!<cr>:OmniSharpBuildAsync<cr>
        " automatic syntax check on events (TextChanged requires Vim 7.4)
        autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck

        " Automatically add new cs files to the nearest project on save
        autocmd BufWritePost *.cs call OmniSharp#AddToProject()

        "show type information automatically when the cursor stops moving
        autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

        "The following commands are contextual, based on the current cursor position.

        autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
        autocmd FileType cs nnoremap <leader>fi :OmniSharpFindImplementations<cr>
        autocmd FileType cs nnoremap <leader>ft :OmniSharpFindType<cr>
        autocmd FileType cs nnoremap <leader>fs :OmniSharpFindSymbol<cr>
        autocmd FileType cs nnoremap <leader>fu :OmniSharpFindUsages<cr>
        "finds members in the current buffer
        autocmd FileType cs nnoremap <leader>fm :OmniSharpFindMembers<cr>
        " cursor can be anywhere on the line containing an issue
        autocmd FileType cs nnoremap <leader>x  :OmniSharpFixIssue<cr>
        autocmd FileType cs nnoremap <leader>fx :OmniSharpFixUsings<cr>
        autocmd FileType cs nnoremap <leader>tt :OmniSharpTypeLookup<cr>
        autocmd FileType cs nnoremap <leader>dc :OmniSharpDocumentation<cr>
        "navigate up by method/property/field
        autocmd FileType cs nnoremap <C-K> :OmniSharpNavigateUp<cr>
        "navigate down by method/property/field
        autocmd FileType cs nnoremap <C-J> :OmniSharpNavigateDown<cr>

    augroup END


    " this setting controls how long to wait (in ms) before fetching type / symbol information.
    set updatetime=500
    " Remove 'Press Enter to continue' message when type information is longer than one line.
    set cmdheight=2

    " Contextual code actions (requires CtrlP or unite.vim)
    nnoremap <leader><space> :OmniSharpGetCodeActions<cr>
    " Run code actions with text selected in visual mode to extract method
    vnoremap <leader><space> :call OmniSharp#GetCodeActions('visual')<cr>

    " rename with dialog
    nnoremap <leader>nm :OmniSharpRename<cr>
    nnoremap <F2> :OmniSharpRename<cr>
    " rename without dialog - with cursor on the symbol to rename... ':Rename newname'
    command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

    " Force OmniSharp to reload the solution. Useful when switching branches etc.
    nnoremap <leader>rl :OmniSharpReloadSolution<cr>
    nnoremap <leader>cf :OmniSharpCodeFormat<cr>
    " Load the current .cs file to the nearest project
    nnoremap <leader>tp :OmniSharpAddToProject<cr>

    " (Experimental - uses vim-dispatch or vimproc plugin) - Start the omnisharp server for the current solution
    nnoremap <leader>ss :OmniSharpStartServer<cr>
    nnoremap <leader>sp :OmniSharpStopServer<cr>

    " Add syntax highlighting for types and interfaces
    nnoremap <leader>th :OmniSharpHighlightTypes<cr>
    "Don't ask to save when changing buffers (i.e. when jumping to a type definition)
    set hidden

    " let g:OmniSharp_server_type = 'v1'
    " let g:OmniSharp_server_type = 'roslyn'
    let g:OmniSharp_selector_ui = 'unite'  " Use unite.vim
    
    
    " Enable snippet completion, requires completeopt-=preview
    " let g:OmniSharp_want_snippet=1
endfunction

let rich=$VIM_RICH_MODE
if rich == '1'
  call s:setup()
  call s:omnisharp()
  call s:syntastic()
endif
