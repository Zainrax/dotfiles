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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" --> Text, tab and indent related <--
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set shiftwidth=2                
set tabstop=2                   
set expandtab                   
set smarttab                    

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---> Remap Keys <---
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader =" "
map <leader>w <Esc>:w<cr><Space>
imap nn <Esc>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" --> Plugins <--
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/plugged')
Plug 'jparise/vim-graphql'
Plug 'honza/vim-snippets'
Plug 'neovimhaskell/haskell-vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'leafOfTree/vim-vue-plugin'
"{{{
  let g:vim_vue_plugin_load_full_syntax = 1
  let g:vim_vue_plugin_use_typescript	= 1
  let g:vim_vue_plugin_use_scss = 1
"}}}
Plug 'vim-syntastic/syntastic'
"{{{
  let g:syntastic_cpp_checkers = ['cpplint']
  let g:syntastic_c_checkers = ['cpplint']
  let g:syntastic_cpp_cpplint_exec = 'cpplint'
  " The following two lines are optional. Configure it to your liking!
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0
"}}}
Plug 'rhysd/vim-clang-format'
"{{{
  autocmd FileType cpp ClangFormatAutoEnable
"}}}
Plug 'jackguo380/vim-lsp-cxx-highlight'
"{{{
  " C++ syntax highlighting
  let g:cpp_class_scope_highlight = 1
  let g:cpp_member_variable_highlight = 1
  let g:cpp_class_decl_highlight = 1
"}}}
Plug 'mileszs/ack.vim'
"{{{
  " Use ripgrep for searching ⚡️
  " Options include:
  " --vimgrep -> Needed to parse the rg response properly for ack.vim
  " --type-not sql -> Avoid huge sql file dumps as it slows down the search
  " --smart-case -> Search case insensitive if all lowercase pattern, Search case sensitively otherwise
  let g:ackprg = 'rg --vimgrep --type-not sql --smart-case'

  " Auto close the Quickfix list after pressing '<enter>' on a list item
  let g:ack_autoclose = 1

  " Any empty ack search will search for the work the cursor is on
  let g:ack_use_cword_for_empty_search = 1

  " Don't jump to first match
  cnoreabbrev Ack Ack!

  " Maps <leader>/ so we're ready to type the search keyword
  nnoremap <Leader>' :Ack!<Space>
  " }}}

  " Navigate quickfix list with ease
  nnoremap <silent> [q :cprevious<CR>
  nnoremap <silent> ]q :cnext<CR> 
"}}}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" {{{
  " Use tab for trigger completion with characters ahead and navigate.
  " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  " other plugin before putting this into your config.
  let g:coc_snippet_next = '<tab>'
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>":
        \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  imap <C-e> <Plug>(coc-snippets-expand)
  " Confirm https://github.com/neoclide/coc.nvim/issues/617
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  inoremap <silent><expr> <c-space> coc#refresh()
  " Use `[g` and `]g` to navigate diagnostics
  " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
  nmap <silent> <Leader>[ <Plug>(coc-diagnostic-prev)
  nmap <silent> <Leader>] <Plug>(coc-diagnostic-next)

  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Remap keys for applying codeAction to the current buffer.
  nmap <silent> ga  <Plug>(coc-codeaction)
  " Apply AutoFix to problem on the current line.
  nmap <silent> gf  <Plug>(coc-fix-current)

  " For finding eslint in workspace
  autocmd FileType typescript let b:coc_root_patterns = [ 'package.json']
  autocmd FileType javascript let b:coc_root_patterns = [ 'package.json']
" }}}
Plug 'easymotion/vim-easymotion'
  " {{{
  let g:EasyMotion_smartcase = 1

  map s <Plug>(easymotion-bd-f2)
  nmap s <Plug>(easymotion-overwin-f2)
  map T <Plug>(easymotion-bd-tl)
" }}}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" {{{
  if has('nvim') && !exists('g:fzf_layout')
    autocmd! FileType fzf
    autocmd  FileType fzf set laststatus=0 noshowmode noruler
      \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
  endif

  command! -bang -nargs=* Rg call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)
  nnoremap <silent> <leader>/ :Files<CR>
  nnoremap <silent> <Leader>f :Rg<CR>
" }}}
Plug 'rstacruz/vim-closer'
Plug 'mattn/emmet-vim'
"{{{
  let g:user_emmet_leader_key=','
"}}}
Plug 'tpope/vim-endwise'
Plug 'morhetz/gruvbox'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
"{{{
  map <C-n> :NERDTreeToggle<CR>
"}}}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" {{{
  let g:airline_theme='deus'         
" }}}
call plug#end()

colorscheme gruvbox
