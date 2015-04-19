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

" Show hard tabs as 4 side, use 2 space indentation rounded to multiples.
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

filetype off
call plug#begin()
" Plugins
Plug 'gmarik/Vundle.vim'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'scrooloose/nerdtree'
Plug 'ervandew/supertab'
Plug 'bufexplorer.zip'
Plug 'ervandew/ag'

" Languages
Plug 'fatih/vim-go' "go
Plug 'othree/yajs.vim' "javascript
Plug 'StanAngeloff/php.vim' "php
Plug 'digitaltoad/vim-jade' "Jade (node template engine)
Plug 'wavded/vim-stylus' "css
Plug 'Glench/Vim-Jinja2-Syntax' "jinja
Plug 'raichoo/haskell-vim' "haskell
Plug 'leafgarland/typescript-vim' "typescript (javascript superset)
Plug 'wting/rust.vim' "Rust
"Plug 'davidhalter/jedi-vim' "Python
Plug 'klen/python-mode' "Python
call plug#end()

" Syntax highlighting, filetype indentation rules.
filetype plugin indent on
syntax on

let pymode = 1
let pymode_breakpoint = 1
let pymode_breakpoint_bind = 'b'
let pymode_doc = 1
let pymode_doc_bind = 'K'
let pymode_folding = 0
let pymode_indent = 1
let pymode_lint = 1
let pymode_lint_checkers = ['pylint', 'pyflakes', 'pep8', 'mccabe']
let pymode_lint_cwindow = 1
let pymode_lint_ignore = ''
let pymode_lint_message = 1
let pymode_lint_on_fly = 0
let pymode_lint_on_write = 1
let pymode_lint_select = ''
let pymode_lint_signs = 1
let pymode_motion = 1
let pymode_options = 1

let pymode_quickfix_maxheight = 6
let pymode_quickfix_minheight = 3
let pymode_rope = 1
let pymode_run = 1
let pymode_run_bind = 'r'
let pymode_trim_whitespaces = 1
let pymode_virtualenv = 1
let pymode_virtualenv_enabled = ''
let pymode_virtualenv_path = ''
let g:pymode_options_max_line_length=95


colorscheme hybrid

" Leader commands
nmap <leader>n :nohlsearch<CR>
noremap <leader>W :w !sudo tee % > /dev/null<CR> " save a file as root (,W)
noremap <leader>nt :NERDTreeToggle<CR>
noremap <leader>be :BufExplorerHorizontalSplit<CR>

noremap <leader>ss :set spell<CR>
noremap <leader>sns :set nospell<CR>
noremap <leader>sp :set paste<CR>
noremap <leader>snp :set nopaste<CR>

autocmd User GoyoEnter Limelight
autocmd User GoyoLeave Limelight!
nnoremap <Leader>z :Goyo<CR>

let g:bufExplorerShowRelativePath=1
autocmd BufNewFile,BufRead *.sl set filetype=solo
autocmd BufNewFile,BufRead *.md setlocal spell
noremap <Leader>gl :GoLint<CR>
autocmd BufWritePost *.go :GoBuild
autocmd BufWritePost *.ts :make
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
