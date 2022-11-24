"--- /|\---- Logos|Eros
"---/ | \--- Patrick Baxter
"--/  |  \-- http://www.logoseros.com/
"-/   |   \-
"-----------

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" --> General Settings <--
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set relativenumber
set expandtab
set hidden
set smartcase
set termguicolors
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set clipboard+=unnamedplus
filetype plugin on
set omnifunc=syntaxcomplete#Complete
let g:omni_sql_no_default_maps = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" --> Text, tab and indent related <--
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set shiftwidth=2                
set tabstop=2                   
set expandtab                   
set smarttab                    
set smartindent

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> Remap Keys <---
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader =" "
let maplocalleader = "\\"
map <leader>w <Esc>:w<cr><Space>
map <F1> <Esc>:e ~/orgs/projects.org<cr>
map <F2> <Esc>:e ~/orgs/inbox.org<cr>
map <Esc><Esc> :noh<return>

function! Cond(Cond, ...)
  let opts = get(a:000, 0, {})
  return a:Cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" --> Plugins <--
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/plugged')
Plug 'phaazon/hop.nvim'
if (!exists('g:vscode'))
" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'simrat39/rust-tools.nvim'
" Completion
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
Plug 'honza/vim-snippets'
Plug 'rafamadriz/friendly-snippets'
Plug 'github/copilot.vim'
" Debugger
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'
Plug 'rcarriga/nvim-dap-ui'
" Motion
Plug 'zhou13/vim-easyescape'
" Format
Plug 'sbdchd/neoformat'
Plug 'mattn/emmet-vim'
"Plug 'cohama/lexima.vim'
" Util
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-telescope/telescope.nvim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-completion'
Plug 'kristijanhusak/vim-dadbod-ui'
" Orgmode
Plug 'nvim-orgmode/orgmode'
Plug 'akinsho/org-bullets.nvim',
" Style
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'navarasu/onedark.nvim'
" Dependencies
Plug 'vim-denops/denops.vim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
endif
call plug#end()
if (!exists('g:vscode'))
let g:coq_settings= { 'auto_start': v:true }
lua require("init")
colorscheme onedark
let g:airline_theme='onedark'         

" === Plugin Config ===
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-e>"
let g:UltiSnipsJumpBackwardTrigger="<c-E>"

nnoremap <F3> :RustRunnables<CR>
nnoremap <F4> :RustDebuggables<CR>
nnoremap <C-f> <Cmd>lua require("dapui").toggle()<CR>
nnoremap <C-Z> <Cmd>lua require("dapui").eval()<CR>
nnoremap <silent> <F5> :lua require'dap'.continue()<CR>
nnoremap <silent> <F6> :lua require'dap'.run_last()<CR>
nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
nnoremap <silent> <F12> :lua require'dap'.step_out()<CR>
nnoremap <silent> <leader>b :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>

" == EasyEscape ==
  let g:easyescape_chars = { "i": 2}
  let g:easyescape_timeout = 100
  inoremap ii <Esc>

" == Emmet ==
  let g:user_emmet_leader_key=","

" == Nerdtree ==
  map <C-n> <cmd>CHADopen<CR>
  nnoremap <leader>l <cmd>call setqflist([])<cr>

" == Telescope ==
  nnoremap <leader>/ <cmd>lua require('telescope.builtin').find_files()<cr>
  nnoremap <leader>g <cmd>lua require('telescope.builtin').git_files()<cr>
  nnoremap <leader>f <cmd>lua require('telescope.builtin').live_grep()<cr>
  nnoremap <leader>t <cmd>lua require('telescope.builtin').treesitter()<cr>
  nnoremap <leader>m <cmd>lua require('telescope.builtin').marks()<cr>
" == Formatter ==
  nnoremap <silent> <leader>z :Format<CR>
  set completeopt-=preview
  autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

  let g:neoformat_try_node_exe = 1
  autocmd BufWritePre *.js Neoformat
  autocmd BufWritePre *.ts Neoformat
  autocmd BufWritePre *.tsx Neoformat
  autocmd BufWritePre *.svelte Neoformat
  autocmd BufWritePre *.vue Neoformat
  autocmd BufWritePre *.rs Neoformat
  autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni
" == Copilot ==
  imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
  let g:copilot_no_tab_map = v:true

" == treesitter ==
autocmd FileType org setlocal nofoldenable
autocmd FileType org setlocal indentexpr=nvim_treesitter#indentexpr()

" == lsp ==
" == EasyMotion ==
  map gd <Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>
  map gr <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>
  map gt <Cmd>call VSCodeNotify('editor.action.goToTypeDefinition')<CR>
  map <leader>] <Cmd>call VSCodeNotify('editor.action.marker.next')<CR>
  map <leader>[ <Cmd>call VSCodeNotify('editor.action.marker.prev')<CR>
lua << EOF
  require('hop').setup()
  vim.api.nvim_set_keymap('', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
  vim.api.nvim_set_keymap('', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
  vim.api.nvim_set_keymap('', 't', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>", {})
  vim.api.nvim_set_keymap('', 'T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>", {})
  vim.api.nvim_set_keymap('', 's', "<cmd>lua require'hop'.hint_char2()<cr>", {})
  vim.api.nvim_set_keymap('', 'h', "<cmd>lua require'hop'.hint_lines()<cr>", {})
EOF
endif
