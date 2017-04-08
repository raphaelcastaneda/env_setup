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
set list listchars=tab:>\ ,trail:·,nbsp:_

" Show hard tabs as 4 wide, use 2 space indentation rounded to multiples
set tabstop=4 expandtab shiftwidth=2 shiftround

" Use mac clipboard
set clipboard=unnamed

" Show tab-complete suggestions and complete longest substring.
set wildmenu wildmode=list:longest

" Resize windows evenly on size change
autocmd VimResized * :wincmd =

" Remove timeouts from esc
set esckeys
set timeoutlen=1000 ttimeoutlen=0

" Send more characters for redraws
set ttyfast

" Enable mouse use in all modes
set mouse=a

" Set terminal name for mouse
set ttymouse=xterm2

" Show visual feedback when leader is pressed
set showcmd

" Swap , and \ for leader.
let mapleader=" "

" Centralize swaps in one folder
set backupdir=~/.vim/backups directory=~/.vim/swaps

" Use silver searcher for vim :grep
if executable('ag')
  " Note that we want column as well as file and line number
  set grepprg=ag\ --nogroup\ --nocolor\ --column
  set grepformat=%f:%l:%c%m
endif

" Powerline setup
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
set laststatus=2

filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

" Plugins
Bundle 'airblade/vim-gitgutter'
Bundle 'junegunn/goyo.vim'
Bundle 'junegunn/limelight.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'Xuyuanp/nerdtree-git-plugin'
Bundle 'ervandew/supertab'
Bundle 'bufexplorer.zip'
Bundle 'ervandew/ag'
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Bundle 'tpope/vim-fugitive'
Bundle 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Bundle 'majutsushi/tagbar'
Bundle 'vim-scripts/ingo-library'
Bundle 'vim-scripts/SyntaxRange'
Bundle 'tpope/vim-dispatch'
Bundle 'tpope/vim-tbone'
Bundle 'tpope/vim-obsession'


" Languages
Bundle 'fatih/vim-go'
Bundle 'othree/yajs.vim'
Bundle 'StanAngeloff/php.vim'
Bundle 'digitaltoad/vim-jade'
Bundle 'wavded/vim-stylus'
Bundle 'Glench/Vim-Jinja2-Syntax'
Bundle 'raichoo/haskell-vim'
Bundle 'leafgarland/typescript-vim'
Bundle 'wting/rust.vim'
Bundle 'klen/python-mode'
Bundle 'davidhalter/jedi-vim'
Bundle 'mfukar/robotframework-vim'
Bundle 'vim-scripts/DrawIt'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-markdown'


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
let pymode_virtualenv_path = ''
let g:pymode_options_max_line_length=120
let g:pymode_lint_options_pylint = {'max-line-length': 120}

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

" syntastic configuration
let g:syntastic_python_checkers = ['flake8', 'pyflakes', 'python']
let g:syntastic_python_flake8_args = '--ignore=E501'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_signs=1

" jedi-vim configuration
let g:jedi#usages_command = '<leader>u'
let g:jedi#use_tabs_not_buffers = 0

" goyo configuration
let g:goyo_width = 120

colorscheme hybrid

" Leader commands
noremap <leader>n :nohlsearch<CR>
noremap <leader>W :w !sudo tee % > /dev/null<CR> " save a file as root (,W)
noremap <leader>nt :NERDTreeToggle<CR>
noremap <leader>tb :TagbarToggle<CR>
noremap <leader>be :BufExplorerHorizontalSplit<CR>

noremap <leader>ss :set spell<CR>
noremap <leader>sns :set nospell<CR>
noremap <leader>sp :set paste<CR>
noremap <leader>snp :set nopaste<CR>

noremap <leader>pl :PymodeLint<CR>
noremap <leader>e :<C-u>call ToggleErrors()<CR>
noremap <leader>] :lnext<CR>
noremap <leader>[ :lprevious<CR>

autocmd User GoyoEnter Limelight
autocmd User GoyoLeave Limelight!
nnoremap <Leader>z :Goyo<CR>


let g:bufExplorerShowRelativePath=1
"autocmd BufNewFile,BufRead *.md setlocal spell
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" Map Ctrl+hjkl to move around splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

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
noremap <leader>j :Twrite last<CR>:Tmux last-pane<CR>
noremap <leader>k :Twrite<CR>
