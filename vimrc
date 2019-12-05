set nocompatible

" Backspace past beginning of line in insert mode.
set backspace=indent,eol,start

" Allow switching buffers without saving.
set hidden

" Show cursor position and incomplete commands, always show status line.
set ruler showcmd laststatus=2

" Search incrementally with smart case sensitivity, highlight all matches.
set incsearch ignorecase smartcase hlsearch

" Automatic indentation and adjust with tab and backspace.
set autoindent smartindent smarttab

" Show line numbers, highlight current line and fixed columns.
set number cursorline colorcolumn=80,100,120

" Set window title.
set title

" Shorten messages and disable intro screen
set shortmess=atI

" Disable audible bell.
set visualbell t_vb=

" Show hard tabs and trailing whitespace
"set list listchars=tab:>\ ,trail:·,nbsp:_

" Fancy istchars
if &encoding == "utf-8"
  exe "set listchars=trail:·,eol:\u00ac,nbsp:\u2423,conceal:\u22ef,tab:\u25b8\u2014,precedes:\u2026,extends:\u2026"
else
  set listchars=trail:·,eol:$,tab:>-,extends:>,precedes:<,conceal:+
endif
set list

" Show hard tabs as 4 wide, use 2 space indentation rounded to multiples
set tabstop=4 expandtab shiftwidth=2 shiftround

" Use mac clipboard
set clipboard=unnamed

" Show tab-complete suggestions and complete longest substring.
set wildmenu wildmode=list:longest

" Resize windows evenly on size change
autocmd VimResized * :wincmd =

" Remove timeouts from esc
if !has('nvim')
  set esckeys
  set timeoutlen=1000 ttimeoutlen=0
endif

" Send more characters for redraws
set ttyfast

" Enable mouse use in all modes
set mouse=a

" Set terminal name for mouse
if !has('nvim')
  set ttymouse=xterm2
endif

" Show visual feedback when leader is pressed
set showcmd

" Swap , and \ for leader.
let mapleader=" "

" Centralize swaps in one folder
set backupdir=~/.vim/backups directory=~/.vim/swaps//

" But no no backups for crontab
autocmd filetype crontab setlocal nobackup nowritebackup

" Use silver searcher for vim :grep
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Powerline setup
"set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
"set laststatus=2

" Airline setup
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_theme = 'powerlineish'

if has('nvim')
    let g:python_host_prog  = 'python2'
    let g:python3_host_prog = 'python3'
endif

filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

" Plugins
Bundle 'airblade/vim-gitgutter'
Bundle 'junegunn/goyo.vim'
Bundle 'junegunn/limelight.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'Xuyuanp/nerdtree-git-plugin'
Bundle 'ervandew/supertab'
Bundle 'ervandew/ag'
"Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Bundle 'tpope/vim-fugitive'
Bundle 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Bundle 'junegunn/fzf.vim'
Bundle 'majutsushi/tagbar'
Bundle 'vim-scripts/ingo-library'
Bundle 'vim-scripts/SyntaxRange'
Bundle 'tpope/vim-dispatch'
Bundle 'tpope/vim-tbone'
Bundle 'tpope/vim-obsession'
Bundle 'vimwiki/vimwiki'
Bundle 'tpope/vim-surround'
Bundle 'vim-airline/vim-airline'
Bundle 'vim-airline/vim-airline-themes'
Bundle 'jiangmiao/auto-pairs'

" Languages
Bundle 'fatih/vim-go', {'do': ':GoUpdateBinaries'}
Bundle 'mdempsky/gocode', {'rtp': 'nvim/'}
Bundle 'StanAngeloff/php.vim'
Bundle 'digitaltoad/vim-jade'
Bundle 'wavded/vim-stylus'
Bundle 'Glench/Vim-Jinja2-Syntax'
Bundle 'raichoo/haskell-vim'
Bundle 'leafgarland/typescript-vim'
Bundle 'wting/rust.vim'
Bundle 'klen/python-mode'
Bundle 'davidhalter/jedi-vim'
Bundle 'Valloric/YouCompleteMe'
Bundle 'mfukar/robotframework-vim'
Bundle 'vim-scripts/DrawIt'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-markdown'
Bundle 'JamshedVesuna/vim-markdown-preview'
Bundle 'pangloss/vim-javascript'
Bundle 'mxw/vim-jsx'
"Bundle 'maksimr/vim-jsbeautify'
Bundle 'prettier/vim-prettier', {'do': 'yarn install'}
Bundle 'w0rp/ale'
Bundle 'othree/xml.vim'
Bundle 'martinda/Jenkinsfile-vim-syntax'


" Syntax highlighting, filetype indentation rules.
filetype plugin indent on
syntax on

let pymode = 1
let pymode_breakpoint = 1
let pymode_breakpoint_bind = 'B'
let pymode_doc = 1
"let pymode_doc_bind = 'K'
let pymode_folding = 0
let pymode_indent = 1
let pymode_lint = 1
let pymode_lint_checkers = ['pyflakes', 'pep8', 'pep257', 'mccabe', 'pylint']
let pymode_lint_cwindow = 1
let pymode_lint_ignore = ''
let pymode_lint_message = 1
let pymode_lint_on_fly = 0
let pymode_lint_on_write = 0
let pymode_lint_select = ''
let pymode_lint_signs = 1
let pymode_motion = 1
let pymode_options = 1

let pymode_quickfix_maxheight = 6
let pymode_quickfix_minheight = 3
let pymode_rope = 0
"let pymode_run = 1
"let pymode_run_bind = 'r'
let pymode_trim_whitespaces = 1
let pymode_virtualenv = 1
let pymode_virtualenv_enabled = ''
let pymode_virtualenv_path = $VIRTUAL_ENV
let g:pymode_options_max_line_length=120
let g:pymode_lint_options_pylint = {'max-line-length': 120}

" Golang settings
let g:go_highlight_types=1
let g:go_highlight_fields=1
let g:go_highlight_functions=1
let g:go_highlight_function_calls=1
let g:go_highlight_operators=1
let g:go_highlight_extra_types=1
let g:go_highlight_build_constraints=1
let g:go_def_mode = "guru"
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 
autocmd FileType go nnoremap <buffer> <leader>u :GoReferrers<CR>
autocmd FileType go nnoremap <buffer> <leader>c :GoCallers<CR>
autocmd FileType go nnoremap <buffer> <leader>d :GoDef<CR>
autocmd FileType go nnoremap <buffer> <leader>e :GoLint<CR>

" Prettier javascript settings
let g:prettier#config#semi = 'false'
let g:prettier#config#single_quote = 'true'
let g:prettier#config#trailing_comma = 'all'
let g:prettier#config#parser = 'flow'
let g:prettier#config#bracket_spacing = 'true'

" ALE lint engine config
"let g:ale_set_loclist = 0
"let g:ale_set_quickfix =1

" Syntastic config
function! ToggleErrors()
    let old_last_winnr = winnr('$')
    lclose
    if old_last_winnr == winnr('$')
        " Nothing was closed, open syntastic error location panel
        SyntasticCheck
        Errors
    endif
endfunction
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"Diff confog for fugitive Gdiff
set diffopt+=vertical

"NerdTree Config
let NERDTreeIgnore = ['\.pyc$']
let NERDTreeDirArrows = 1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"
" returns true iff is NERDTree open/active
function! IsNTOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" calls NERDTreeFind iff NERDTree is active, current window contains a modifiable file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNTOpen() && strlen(expand('%')) > 0 && !&diff
    let l:curwinnr = winnr()
    NERDTreeFind
    exec l:curwinnr . "wincmd w"
  endif
endfunction

autocmd vimenter * NERDTree
autocmd BufEnter * call SyncTree()

let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "Δ",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }
" Speed improvements
set nocursorcolumn
"set nocursorline
syntax sync minlines=256
set re=1

" syntastic configuration
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args = '--ignore=E501'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_signs=1
let g:syntastic_enable_highlighting=0
"let g:syntastic_echo_current_error = 0
let g:syntastic_cursor_column = 0

" jedi-vim configuration
let g:jedi#completions_enabled = 0
let g:jedi#usages_command = '<leader>u'
let g:jedi#use_tabs_not_buffers = 0

" YouCompleteMe Configuration
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_server_python_interpreter = 'python3'
let g:ycm_python_binary_path = 'python3'

" AutoPairs config
let g:AutoPairsShortcutFastWrap = '<c-e>'

" FZF configuration
" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" JS Beautify
autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
" for json
autocmd FileType json noremap <buffer> <c-f> :call JsonBeautify()<cr>
" for jsx
autocmd FileType jsx noremap <buffer> <c-f> :call JsxBeautify()<cr>
" for html
autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
" for css or scss
autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>

" Advanced customization using autoload functions
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})"
" goyo configuration
let g:goyo_width = 120

colorscheme hybrid

" markdown preview
let vim_markdown_preview_github=1
let vim_markdown_preview_temp_file=0

" vimwiki/vimwiki
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md', 'auto_tags': 1 }]
autocmd FileType vimwiki nmap <buffer> <Enter> <Plug>VimwikiFollowLink
let g:vimwiki_table_mappings = 0
let g:vimwiki_hl_cb_checked = 1
let g:vimwiki_global_ext = 0
let g:vimwiki_folding = ''

" Location List browsing
function! ToggleLocation()
    let old_last_winnr = winnr('$')
    lclose
    if old_last_winnr == winnr('$')
        lopen
    endif
endfunction

noremap <leader>l :<C-u>call ToggleLocation()<CR>
noremap <leader>j :lnext<CR>
noremap <leader>k :lprev<CR>

" Leader commands
noremap <leader>n :nohlsearch<CR>
noremap <leader>W :w !sudo tee % > /dev/null<CR> " save a file as root (,W)
noremap <leader>nt :NERDTreeToggle<CR>

noremap <leader>tb :TagbarToggle<CR>

noremap <leader>be :Buffers<CR>
noremap <leader>f :Files<CR>
noremap <leader>f :Files<CR>
noremap <leader>g :GitFiles<CR>

noremap <leader>ss :set spell<CR>
noremap <leader>sns :set nospell<CR>
noremap <leader>sp :set paste<CR>
noremap <leader>snp :set nopaste<CR>

noremap <leader>pl :PymodeLint<CR>
noremap <leader>e :<C-u>call ToggleErrors()<CR>
noremap <leader>] :lnext<CR>
noremap <leader>[ :lprevious<CR>
noremap <leader>q :ccl<CR>

autocmd User GoyoEnter Limelight
autocmd User GoyoLeave Limelight!
nnoremap <Leader>z :Goyo<CR>

noremap <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

let g:bufExplorerShowRelativePath=1
"autocmd BufNewFile,BufRead *.md setlocal spell
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" Map Ctrl+hjkl to move around splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Map F to find work under cursor
nnoremap F :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

map <Up> <NOP>
map <Down> <NOP>
map <Left> <NOP>
map <Right> <NOP>
imap <Up> <NOP>
imap <Down> <NOP>
imap <Left> <NOP>
imap <Right> <NOP>

" dispatch config
noremap <F9> :Dispatch<CR>
autocmd FileType python let b:dispatch = 'tox'

" tbone config
noremap <leader>b :Twrite .last<CR> :Tmux last-pane<CR>
