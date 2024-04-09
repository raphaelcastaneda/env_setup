lua << EOF
vim.g.loaded=1
vim.g.loaded_netrwPlugin=1
EOF
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
"set number cursorline colorcolumn=80,100,120
set number cursorline colorcolumn=120,160

" Set window title.
set title

" Use abbreviations, truncate messages, disable intro screen, and disable info
set shortmess=atIF

" Disable audible bell.
set visualbell t_vb=

" Show hard tabs and trailing whitespace
"set list listchars=tab:>\ ,trail:·,nbsp:_

" Fancy listchars -- shows connecting lines on indentation levels
set list
if &encoding == "utf-8"
  exe "set listchars=trail:·,eol:\u00ac,nbsp:\u2423,conceal:\u22ef,tab:\u2502\u2508,precedes:\u2026,extends:\u2026"
else
  set listchars=trail:·,eol:$,tab:>-,extends:>,precedes:<,conceal:+
endif

" support undercurl in iTerm2 and friends
let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"

" Show hard tabs as 4 wide, use 4 space indentation rounded to multiples
set tabstop=4 expandtab shiftwidth=4 shiftround

" Use mac clipboard
set clipboard=unnamed

" Show tab-complete suggestions and complete longest substring.
"set wildmenu wildmode=list:longest

" Resize windows evenly on size change
autocmd VimResized * :wincmd =

" Remove timeouts from esc
if !has('nvim')
  set esckeys
  set timeoutlen=1000 ttimeoutlen=0
endif

"
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
"
" No swap files
set noswapfile

" Set faster updatetime to speed up cursorhold events
set updatetime=250

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
let g:ctrlp_working_path_mode = 'ra'

" Powerline setup
"set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
"set laststatus=2

if has('nvim')
" Figure out the system Python for Neovim.
  if exists("$VIRTUAL_ENV")
      let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
      "let g:python3_host_prog=substitute(system("which -a python3 | head -n2 | tail -n1"), "\n", '', 'g')
  else
      let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
  endif
  "let g:python_host_prog  = 'python2'
  "let g:python3_host_prog = 'python'
endif

filetype off

" if has('nvim')
"   let s:plugPath = '~/.config/nvim/autoload/plug.vim'
"   let s:bundlePath = '~/.config/nvim/bundle/'
" else
"   let s:plugPath = '~/.vim/autoload/plug.vim'
"   let s:bundlePath = '~/.vim/bundle/'
" endif
" 
" let s:freshInstall = 0
" if empty(glob(s:plugPath))
"   let s:freshInstall = 1
"   execute '!curl -fLo ' . s:plugPath . ' --create-dirs ' .
"         \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" endif


" call plug#begin(s:bundlePath)
" call plug#end()
" if s:freshInstall
"   echo "Installing Plugins..."
"   PlugInstall
" endif

" Appearance options
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"
"let g:gruvbox_italic=1
"let g:gruvbox_transparent_bg = 1
"let g:gruvbox_contrast_dark = 'hard'
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let g:enable_bold_font = 1
let g:enable_italic_font = 1
set background=dark
"colorscheme leaf
"colorscheme catppuccin
"colorscheme hybrid
"colorscheme base16-tomorrow-night-eighties
"let g:hybrid_use_iTerm_colors = 1
"transparent background
au ColorScheme * hi Normal ctermbg=none guibg=none
au ColorScheme * hi NonText ctermbg=none guibg=none ctermfg=239 guifg=#585c63
hi Normal ctermbg=none guibg=none
hi NonText ctermbg=none guibg=none ctermfg=239 guifg=#585c63

" Nvim tree transparent background
hi NvimTreeNormal guibg=none

" Limelight / Goyo appearance
let g:limelight_conceal_ctermfg = 'DarkGray'
let g:limelight_conceal_guifg = 'black'
let g:limelight_priority = -1

" LSP Statusline
function! LspStatus() abort
  let status = luaeval("require('lsp-status').status()")
  return trim(status)
endfunction

" Airline setup
call airline#parts#define_function('lsp_status', 'LspStatus')
call airline#parts#define_condition('lsp_status', 'luaeval("#vim.lsp.buf_get_clients() > 0")')
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#tab_nr_show = 1
let g:airline#extensions#tabline#tab_nr_type = 1
"let g:airline#extensions#tabline#formatter = 'default'
let g:airline_theme = 'catppuccin'
"let g:airline_theme = 'hybridline'
"let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#branch#displayed_head_limit = 30
let g:airline#extensions#nvimlsp#enabled = 1
let airline#extensions#nvimlsp#error_symbol = ' '
let airline#extensions#nvimlsp#warning_symbol = ' '
let g:airline_section_warning = airline#section#create_right(['lsp_status'])  " replaces the warning section with the lsp status indicator

let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffer_idx_format = {
      \ '0': '0 ',
      \ '1': '1 ',
      \ '2': '2 ',
      \ '3': '3 ',
      \ '4': '4 ',
      \ '5': '5 ',
      \ '6': '6 ',
      \ '7': '7 ',
      \ '8': '8 ',
      \ '9': '9 '
      \}

nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>0 <Plug>AirlineSelectTab0

" Syntax highlighting, filetype indentation rules.
filetype plugin indent on

syntax on
"let g:semshi#simplify_markup = get(g:, 'semshi#simplify_markup', v:false)
"let g:pymode = 1
"let g:pymode_breakpoint = 1
"let g:pymode_breakpoint_bind = 'B'
"let g:pymode_doc = 1
""let pymode_doc_bind = 'K'
"let g:pymode_folding = 0
"let g:pymode_indent = 1
"let g:pymode_lint = 0
"let g:pymode_lint_checkers = [] " 'pyflakes', 'pep8', 'pep257', 'mccabe', 'pylint']
"let g:pymode_lint_cwindow = 1
"let g:pymode_lint_message = 1
"let g:pymode_lint_on_fly = 0
"let g:pymode_lint_on_write = 0
"let g:pymode_lint_select = ''
"let g:pymode_lint_signs = 1
"let g:pymode_motion = 1
"let g:pymode_options = 1
"
"let g:pymode_quickfix_maxheight = 6
"let g:pymode_quickfix_minheight = 3
"let g:pymode_rope = 0
"let pymode_run = 1
"let pymode_run_bind = 'r'
"let g:pymode_trim_whitespaces = 1
"let g:pymode_virtualenv = 1
"let g:pymode_virtualenv_enabled = ''
"let g:pymode_virtualenv_path = $VIRTUAL_ENV
"let g:pymode_options_max_line_length=120
"let g:pymode_lint_ignore = ['E126', 'D100', 'D101', 'D102', 'D103', 'D205', 'D400', 'D401']
"let g:pymode_lint_options_pep8 = {'max-line-length': g:pymode_options_max_line_length}
"let g:pymode_lint_options_pylint = {'max-line-length': g:pymode_options_max_line_length}
"let g:pymode_lint_options_pep257 = {'ignore': 'D100,D101,D102,D103,D205,D400,D401'}
"
" Vimspector settings
let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_install_gadgets = [ 'vscode-go' ]
let g:vimspector_variables_display_mode = 'full'
let g:vimspector_base_dir=expand('$HOME/.local/share/nvim/site/pack/packer/start/vimspector')

" for normal mode - the word under the cursor
nmap <leader>vl :call vimspector#Launch()<CR>
nmap <leader>vr :VimspectorReset<CR>
nmap <leader>ve :VimspectorEval
nmap <leader>vw :VimspectorWatch
nmap <leader>vo :VimspectorShowOutput
nmap <leader>vi <Plug>VimspectorBalloonEval
xmap <leader>vi <Plug>VimspectorBalloonEval
"

" Golang settings
"autocmd BufWritePre *.go lua vim.lsp.buf.formatting_seq_sync()
let g:go_highlight_types=1
let g:go_highlight_fields=1
let g:go_highlight_functions=1
let g:go_highlight_function_calls=1
let g:go_highlight_operators=1
let g:go_highlight_extra_types=1
let g:go_highlight_build_constraints=1
"let g:go_def_mode = "gopls"
"let g:go_info_mode = "gopls"
"let g:go_doc_keywordprg_enabled=0
" Launch gopls when Go files are in use
"let g:LanguageClient_serverCommands = {
"       \ 'go': ['gopls']
"       \ }
" Run gofmt on save
" autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()
" Ale use gopls
" let g:ale_linters = {
"       \ 'go': ['gopls'],
"       \}

autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd BufNewFile,BufRead *.lua setlocal expandtab tabstop=2 shiftwidth=2
autocmd BufNewFile,BufRead *.js setlocal expandtab tabstop=2 shiftwidth=2
autocmd BufNewFile,BufRead *.tsx setlocal expandtab tabstop=2 shiftwidth=2
autocmd BufNewFile,BufRead *.ts setlocal expandtab tabstop=2 shiftwidth=2
autocmd BufNewFile,BufRead *.json setlocal expandtab tabstop=4 shiftwidth=4
autocmd BufNewFile,BufRead *.yaml setlocal expandtab tabstop=2 shiftwidth=2
autocmd BufNewFile,BufRead *.proto setlocal expandtab tabstop=2 shiftwidth=2
"autocmd FileType go nnoremap <buffer> <leader>u :GoReferrers<CR>
"autocmd FileType go nnoremap <buffer> <leader>c :GoCallers<CR>
"autocmd FileType go nnoremap <buffer> <leader>d :GoDef<CR>
"autocmd FileType go nnoremap <buffer> <leader>e :GoMetaLinter<CR>

" Close hidden buffers
function! DeleteHiddenBuffers()
  let tpbl=[]
  let closed = 0
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    "if exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) == buf)
    "  continue
    if getbufvar(buf, '&mod') == 0
      silent execute 'bwipeout' buf
      let closed += 1
    endif
  endfor
  echo "Closed ".closed." hidden buffers"
endfunction

" Prettier javascript settings
"let g:prettier#config#semi = 'false'
"let g:prettier#config#single_quote = 'true'
"let g:prettier#config#trailing_comma = 'all'
"let g:prettier#config#parser = 'flow'
"let g:prettier#config#bracket_spacing = 'true'
let g:prettier#config#config_precedence = 'file-override'

" vue javascript
"autocmd BufEnter,BufRead *.vue set filetype=vue.javascript

"Diff confog for fugitive Gdiff
set diffopt+=vertical

" NERDCommenter
let g:NERDCreateDefaultMappings = 0

"DevIcons config
"let g:webdevicons_enable_nerdtree = 1
"let g:webdevicons_enable_ctrlp = 1
"augroup my-glyph-palette
"  "autocmd! *
"  autocmd FileType nerdtree call glyph_palette#apply()
"augroup END

"NerdTree Config
"let NERDTreeIgnore = ['\.pyc$', '__pycache__$']
"let NERDTreeDirArrows = 1
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"
" Check if NERDTree is open or active
"function! IsNERDTreeOpen()
"  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
"endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
"function! SyncTree()
"  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
"    NERDTreeFind
"    wincmd p
"  endif
"endfunction

" Keep NERDTree in sync when toggling
"function! ToggleAndSyncTree()
"  if !IsNERDTreeOpen()
"    NERDTreeFind
"  else
"    NERDTreeToggle
"  endif
"endfunction

"autocmd vimenter * NERDTree | NERDTreeClose "Automatically open and close NT on launch to avoid double window error
"autocmd BufEnter * if &modifiable && IsNERDTreeOpen() && &ft !="nerdtree" | call SyncTree()
"
"let g:NERDTreeGitStatusIndicatorMapCustom = {
"      \ "Modified"  : "𝝙",
"      \ "Staged"    : "✚",
"      \ "Untracked" : "✭",
"      \ "Renamed"   : "➜",
"      \ "Unmerged"  : "═",
"      \ "Deleted"   : "✖",
"      \ "Dirty"     : "✗",
"      \ "Clean"     : "✔︎",
"      \ "Unknown"   : "?"
"      \ }

" Speed improvements
set nocursorcolumn
"set lazyredraw
"set nocursorline
syntax sync minlines=2000
"set re=1

" jedi-vim configuration
"let g:jedi#completions_enabled = 0
"let g:jedi#usages_command = '<leader>u'
"let g:jedi#use_tabs_not_buffers = 0


" neovim builtin language client
lua << EOF
require('plugins')
require('lang_config')
require('treesitter_workaround')
require('rainbow_delimiters')
require("theme")
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])
vim.o.timeout = true
vim.o.timeoutlen = 1000
require("which-key").setup({})
EOF

" gitsigns highlight
highlight! link GitSignsAdd diffAdded
highlight! link GitSignsChange diffChanged
highlight! link GitSignsDelete diffRemoved

" hs-lens search highlighting
hi default link HlSearchNear IncSearch
hi default link HlSearchLens WildMenu
hi default link HlSearchLensNear IncSearch
"
" LSP diagnostic highlighting
highlight! link DiagnosticUnderlineError CocErrorHighlight
highlight! link DiagnosticUnderlineHint CocHintHighlight
highlight! link DiagnosticUnderlineInfo CocInfoHighlight
highlight! link DiagnosticUnderlineWarn CocWarningHighlight
"highlight! link DiagnosticError CocErrorSign
"highlight! link DiagnosticDefaultError CocErrorSign
"highlight! link DiagnosticWarn CocWarningSign
"highlight! link DiagnosticDefaultWarning CocWarningSign
"highlight! link DiagnosticHint CocHintSign
"highlight! link DiagnosticDefaultHint CocHintSign
"highlight! link DiagnosticInformation CocInformationSign
"highlight! link DiagnosticDefaultInformation CocInformationSign
"highlight! link DiagnosticSignError CocErrorSign
"highlight! link DiagnosticSignHint CocHintSign
"highlight! link DiagnosticSignInfo CocInfoSign
"highlight! link DiagnosticSignWarn CocWarningSign
"highlight! link DiagnosticSignWarning CocWarningSign
"highlight! link DiagnosticVirtualTextError DiagnosticSignError
"highlight! link DiagnosticVirtualTextHint DiagnosticSignHint
"highlight! link DiagnosticVirtualTextInfo DiagnosticSignInfo
"highlight! link DiagnosticVirtualTextWarn DiagnosticSignWarning
"highlight! link LspReferenceRead CocHighlightRead
"highlight! link LspReferenceText CocHighlightText
"highlight! link LspReferenceWrite CocHighlightWrite

""" Errors in Red
"hi DiagnosticUnderline gui=undercurl cterm=undercurl term=undercurl
"hi DiagnosticUnderlineError gui=undercurl cterm=undercurl term=undercurl guisp=Red
""" Warnings in Yellow
"hi LspDiagnosticsVirtualTextWarning guifg=Yellow ctermfg=Yellow
"hi LspDiagnosticsUnderlineWarning gui=undercurl term=undercurl cterm=undercurl guisp=Yellow
""" Info and Hints in White
hi LspDiagnosticsVirtualTextInformation guifg=White ctermfg=White
hi LspDiagnosticsUnderlineInformation gui=undercurl cterm=undercurl term=undercurl guisp=White
hi LspDiagnosticsVirtualTextHint guifg=White ctermfg=White
hi LspDiagnosticsUnderlineHint gui=undercurl cterm=undercurl term=undercurl guisp=White


"augroup LSPConfig
"  autocmd!
"  autocmd Filetype dockerfile setlocal omnifunc=v:lua.vim.lsp.omnifunc
"  autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc
"  autocmd Filetype yaml setlocal omnifunc=v:lua.vim.lsp.omnifunc
"  autocmd Filetype go setlocal omnifunc=v:lua.vim.lsp.omnifunc
"  autocmd Filetype proto setlocal omnifunc=v:lua.vim.lsp.omnifunc
"augroup END
let g:diagnostic_enable_virtual_text = 0
let g:diagnostic_enable_underline = 1
"autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
"autocmd CursorHold * lua require'lspsaga.hover'.render_hover_doc()

" Treesitter Config
lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = { "go", "python", "lua", "vim", "vimdoc", "yaml" },
  ignore_install = {"vimwiki"}, -- List of parsers to ignore installing
  symbol_in_winbar = {
      enable = false

  },
  highlight = {
    enable = true,              -- false will disable the whole extension
    --disable = { "c", "rust" },  -- list of language that will be disabled
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,
    additional_vim_regex_highlighting = false,
  },
}
EOF
set nofoldenable

" Treesitter alias highlights
hi @comment cterm=italic gui=italic ctermfg=245 guifg=#707880
hi @constant.builtin cterm=italic gui=italic ctermfg=224 guifg=Orange

" highlight link LspSagaDiagnosticHeader Normal
" highlight link LspSagaDiagnosticBorder NonText
" highlight link LspSagaDiagnosticTruncateLine Comment

" lsp diagnostics icons and color fallback
lua << EOF
require("lsp-colors").setup({
  Error = "#db4b4b",
  Warning = "#e0af68",
  Information = "#0db9d7",
  Hint = "#10B981"
})
require("trouble").setup {
    multiline = true, -- render multi-line messages
    indent_lines = true, -- add an indent guide below the fold icons
    win_config = { border = "single" }, -- window configuration for floating windows. See |nvim_open_win()|.
    auto_open = false, -- automatically open the list when you have diagnostics
    auto_close = false, -- automatically close the list when you have no diagnostics
    auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
    auto_fold = false, -- automatically fold a file trouble list at creation 
    signs = {
        error = " ",
        warning = " ",
        hint = " ",
        information = " " ,
        other = "󱐋 "
        },
    }
EOF
noremap <silent> <leader>e :TroubleToggle document_diagnostics<CR>
nnoremap <silent> <leader>we :TroubleToggle workspace_diagnostics<CR>

nnoremap <silent> <leader>c :Gitsigns setqflist<CR>
nnoremap <silent> <leader>A :HFccToggleAutoSuggest<CR>

"    find cursor word definition and references
"nnoremap <silent> gh <cmd>lua require'lspsaga.provider'.lsp_finder()<CR>
"    code actions
"nnoremap <silent> <leader>a <cmd>lua require('lspsaga.codeaction').code_action()<CR>
"vnoremap <silent> <leader>a :<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>
"    hover
"nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
"nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
"nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
"    signature help
"nnoremap <silent> s <cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>
"   rename
"nnoremap <leader>r <cmd>lua require('lspsaga.rename').rename()<CR>
"   preview definition
"nnoremap <silent> gd :Lspsaga preview_definition<CR>
"    diagnostics
"nnoremap <silent><leader>cd <cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>
"nnoremap <silent> <leader>x <cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>

"nnoremap <leader>cb :call DeleteHiddenBuffers()<CR>
" LanguageClient
"let g:LanguageClient_serverCommands = {
"    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
"    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
"    \ 'python': ['pyls'],
"    \ 'go': ['$GOPATH/bin/go-langserver'],
"    \ }
"nmap <F3> <Plug>(lcn-menu)
"" Or map each action separately
"nmap <silent>K <Plug>(lcn-hover)
"nmap <silent> gd <Plug>(lcn-definition)
"nmap <silent> <F2> <Plug>(lcn-rename)

" Deoplete
"let g:deoplete#enable_at_startup=1

" Nvim completion
"set completeopt-=preview
"set completeopt=longest,menuone
"set completeopt=menuone,noinsert,noselect
"let g:completion_enable_auto_hover = 1
"let g:completion_enable_auto_popup = 1
"let g:completion_auto_change_source = 0
"let g:completion_menu_length = 3
"let g:completion_trigger_keyword_length = 1
"let g:completion_enable_auto_signature = 1
"let g:completion_sorting = "none"
"let g:completion_matching_smart_case = 1
"let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']
"let g:completion_trigger_character = ['.', '::']
"let g:completion_enable_snippet = 'UltiSnips'
"let g:completion_menu_length = 40
"imap <tab> <Plug>(completion_smart_tab)
"imap <s-tab> <Plug>(completion_smart_s_tab)

" ultisnips config
"let g:UltiSnipsExpandTrigger="<C-j>"
"let g:UltiSnipsJumpForwardTrigger="<C-l>"
"let g:UltiSnipsJumpBackwardTrigger="<C-h>"
"let g:UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'
"let g:UltiSnipsJumpForwardTrigger = '<Plug>(ultisnips_jump_forward)'
"let g:UltiSnipsJumpBackwardTrigger = '<Plug>(ultisnips_jump_backward)'
"let g:UltiSnipsListSnippets = '<c-x><c-s>'
"let g:UltiSnipsRemoveSelectModeMappings = 0
"vim-vsnip config

" Expand or jump
" imap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'
" smap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'
"
" " Jump forward or backward
" imap <expr> <C-l>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<C-l>'
" smap <expr> <C-l>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<C-l>'
" imap <expr> <C-h> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-h>'
" smap <expr> <C-h> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-h>'
"
" " Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" " See https://github.com/hrsh7th/vim-vsnip/pull/50
" nmap        s   <Plug>(vsnip-select-text)
" xmap        s   <Plug>(vsnip-select-text)
" nmap        S   <Plug>(vsnip-cut-text)
" xmap        S   <Plug>(vsnip-cut-text)

" YouCompleteMe Configuration
"let g:ycm_autoclose_preview_window_after_completion=1
"let g:ycm_server_python_interpreter = 'python3'
"let g:ycm_python_binary_path = 'python3'
"let g:ycm_python_intepreter_path = ''
"let g:ycm_python_sys_path = []
"let g:ycm_extra_conf_vim_data = [
"  \  'g:ycm_python_interpreter_path',
"  \  'g:ycm_python_sys_path'
"  \]
"let g:ycm_global_ycm_extra_conf = '$HOME/.config/nvim/ycm_global_extra_conf.py'

" Other Lua Plugins config
lua << EOF
require("nvim-autopairs").setup {}
require("nvim-web-devicons").setup {
    color_icons = true;
    -- override_by_extension = {
    -- ["go"] = {
    --     icon = "",
    --     color = "#34c0eb",
    --     name = "Go"
    --     }
    -- };
}
require("telescope").setup {}
require("nvim-tree").setup {  
    update_cwd          = false,
    update_focused_file = {
        enable      = true,
        update_cwd  = false,
        ignore_list = {},
     },
}
require('telescope').load_extension('fzf')
vim.g.bufonly_delete_non_modifiable = false -- Don't close nerdtree and other non-editable buffers
vim.api.nvim_set_keymap('n', '<leader>cb', ':BufOnly<CR>', { noremap = true, silent = true })
EOF

" FZF configuration
" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
"imap <c-x><c-k> <plug>(fzf-complete-word)
"imap <c-x><c-f> <plug>(fzf-complete-path)
"imap <c-x><c-j> <plug>(fzf-complete-file-ag)
"imap <c-x><c-l> <plug>(fzf-complete-line)
let g:fzf_buffers_jump = 1

" Advanced customization using autoload functions
"inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})"
" goyo configuration
let g:goyo_width = 120


" iamcco/markdown-preview
"let g:mkdp_browser = 'Chrome'
nmap mp <Plug>MarkdownPreviewToggle

" markdown syntax highlighting
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'vim', 'go', 'javascript', 'cpp']

  augroup VimrcAuGroup
    autocmd!
    autocmd FileType vimwiki setlocal foldmethod=expr |
      \ setlocal foldenable | set foldexpr=VimwikiFoldLevelCustom(v:lnum)
  augroup END

" vimwiki/vimwiki
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md', 'auto_tags': 1 }]
autocmd FileType vimwiki setlocal shiftwidth=4 softtabstop=4
autocmd FileType vimwiki nmap <buffer> <Enter> <Plug>VimwikiFollowLink
let g:vimwiki_table_mappings = 0
let g:vimwiki_hl_cb_checked = 1
let g:vimwiki_global_ext = 0
let g:vimwiki_folding = 'custom'
let g:markdown_folding = 0

function! VimwikiFoldLevelCustom(lnum)
let pounds = strlen(matchstr(getline(a:lnum), '^#\+'))
if (pounds)
    return '>' . pounds  " start a fold level
endif
if getline(a:lnum) =~? '\v^\s*$'
    if (strlen(matchstr(getline(a:lnum + 1), '^#\+')))
    return '-1' " don't fold last blank line before header
    endif
endif
return '=' " return previous fold level
endfunction

"makes vimwiki markdown links generate as [text](text.md)
let g:vimwiki_markdown_link_ext = 1

" Taskwiki
let g:taskwiki_markup_syntax = 'markdown'
let g:taskwiki_conceallevel = 2
let g:taskwiki_disable_concealcursor = ""


" Location List browsing
function! ToggleLocation()
  let old_last_winnr = winnr('$')
  lclose
  if old_last_winnr == winnr('$')
    lopen
  endif
endfunction


" Leader commands
noremap <leader>n :nohlsearch<CR>
noremap <leader>W :w !sudo tee % > /dev/null<CR> " save a file as root (,W)
"noremap <leader>nt :call ToggleAndSyncTree()<CR>
"noremap <leader>nf :NERDTreeFocus<CR>
noremap <leader>nt :NvimTreeFindFileToggle<CR>
noremap <leader>nf :NvimTreeFindFile<CR>


"noremap <leader>tb :TagbarToggle<CR>

" Telescope finder shortcuts
nnoremap <leader>f <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>F <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>be <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>h <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>G <cmd>lua require('telescope.builtin').git_files()<cr>

"noremap <leader>be :Buffers<CR>
"noremap <leader>f :Files<CR>
"noremap <leader>F :Rg<CR>
"noremap <leader>G :GitFiles<CR>

noremap <leader>ss :set spell<CR>
noremap <leader>sns :set nospell<CR>
noremap <leader>sp :set paste<CR>
noremap <leader>snp :set nopaste<CR>
"
" Location list navigation
"noremap <leader>l :<C-u>call ToggleLocation()<CR>
"noremap <leader>j :lnext<CR>
"noremap <leader>k :lprev<CR>

" Quickfix navigation
noremap <leader>q :ccl<CR>
noremap <leader>j :cnext<CR>
noremap <leader>k :cprevious<CR>

"noremap <leader>pl :PymodeLint<CR>
"noremap <leader>e :<C-u>call ToggleErrors()<CR>

autocmd User GoyoEnter Limelight
autocmd User GoyoLeave Limelight!
nnoremap <Leader>z :Goyo<CR>

"noremap <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
"noremap <leader>u  :YcmCompleter GoToReferences<CR>

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
"autocmd FileType python noremap <F9> :Dispatch<CR>
"autocmd FileType python let b:dispatch = 'tox'

" tbone config
noremap <leader><Down> :Twrite .last<CR> :Tmux last-pane<CR>

