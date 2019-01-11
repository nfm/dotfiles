" Vundle required config
filetype off
set rtp+=~/.vim/bundle/Vundle.vim

" Plugins
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-speeddating'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-unimpaired'
Plugin 'kchmck/vim-coffee-script'
Plugin 'matchit.zip'
Plugin 'kana/vim-textobj-user'
Plugin 'nelstrom/vim-textobj-rubyblock'
Plugin 'vim-ruby/vim-ruby'
Plugin 'mileszs/ack.vim'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdtree'
Plugin 'jpalardy/vim-slime'
Plugin 'neomake/neomake'
Plugin 'scrooloose/nerdcommenter'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'altercation/vim-colors-solarized'
Plugin 'airblade/vim-gitgutter'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'ivalkeen/vim-ctrlp-tjump'
Plugin 'mtscout6/vim-cjsx'
Plugin 'elixir-lang/vim-elixir'
Plugin 'othree/yajs.vim'
Plugin 'christoomey/vim-sort-motion'
Plugin 'mxw/vim-jsx'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'editorconfig/editorconfig-vim'
call vundle#end()

set history=10000
syntax on
" Show unfinished commands in the status line
set showcmd
" Show line/column position of cursor in the status line
set ruler
" Fix slow O inserts after hitting ESC
set timeout timeoutlen=1000 ttimeoutlen=100

" Set up colors, use solarized
set t_Co=256
set background=dark
colorscheme solarized

" Whitespace options
set autoindent
set smartindent
set smarttab
set nowrap
set backspace=eol,start,indent
set shiftwidth=2 
set tabstop=2

" Show line numbers
set number
set relativenumber
" Use lighter line number color
highlight LineNr ctermfg=Grey

" Always show the tab line and status line
set showtabline=2
set laststatus=2

" Dictionary options
set spelllang=en_au
set spellfile=~/.vim/dict.add

" Search
" Only do case-sensitive search for searches that contain upper-case characters
set ignorecase smartcase
set incsearch
set hlsearch

" Show matching brace when a closing brace is inserted
set showmatch

" Turn backup off
set nobackup
set nowb
set noswapfile

filetype plugin indent on
set shiftwidth=2 tabstop=2 expandtab

" Set leader key
let mapleader=","

" Map normal mode keyboard shortcuts for tabs
nmap <C-H> :tabp<CR>
nmap <C-L> :tabn<CR>

" Unmap <F1> showing :help
nmap <F1> <nop>

" Map jj to escape in insert mode
inoremap jj <Esc>

" Don't un-indent leading hashes
inoremap # X#

" Make Y behave like other capitals
map Y y$

" Make typing : easier
nnoremap ; :

" Make saving easier
nnoremap <Leader>w :w<CR>

" Turn off search highlighting
nnoremap <Leader>n :nohlsearch<CR>

" Toggle paste mode
set pastetoggle=<Leader>p

" Close tabs quicker
nnoremap <Leader>q :close<CR>

" Shortcuts for tags
nnoremap <Leader>tt :tag 
nnoremap <Leader>tn :tnext<CR>
nnoremap <Leader>tp :tprevious<CR>
nnoremap <Leader>tb :TagbarToggle<CR>
nnoremap <C-]> :CtrlPtjump<CR>
vnoremap <C-]> :CtrlPtjumpVisual<CR>

" Shortcuts for navigating between windows
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Always enter insert mode when navigating to a terminal buffer
autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif

" Open horizontal split below the current window instead of above it
set splitbelow

function! RailsConsole()
  execute "10split"

  try
    " Try to switch to the Rails console buffer
    execute "buffer console"
  catch /^Vim\%((\a\+)\)\=:E94/
    " Start a Rails console buffer if there isn't one already open
    execute "terminal bin/rails console" | execute "set hidden" | execute "file console"
  endtry
endfunction

command! RailsConsole call RailsConsole()
nnoremap <Leader>rc :RailsConsole<CR>

" Shortcut to open a zsh terminal in a split
nnoremap <Leader>te :20split term://zsh<CR>

" Configure wildcard expansion
set wildmenu
set wildignore+=*/tmp

" Configure ack.vim to use ag if available
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Search for word under cursor using ack.vim
nnoremap K :Ack!<CR>

" Don't jump to first result when searching using ack.vim
cnoreabbrev Ack Ack!

" Automatically delete and yank into the system clipboard
set clipboard+=unnamedplus

" Disable the mouse (NeoVim defaults to mouse=a)
set mouse=

" Configure vim-slime
let g:slime_target = "tmux"
let g:slime_paste_file = tempname()

" Configure neomake
autocmd! BufWritePost * Neomake
let g:neomake_open_list=2
let g:neomake_list_height=2
let g:neomake_ruby_enabled_makers = ['rubocop']
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_jsx_enabled_makers = ['eslint']
" TODO: Better handling of locally installed eslint
let g:neomake_javascript_eslint_exe = $PWD .'/node_modules/.bin/eslint'

" Configure CtrlP and plugins
let g:ctrlp_tjump_only_silent = 1
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" Configure rails.vim
let g:rails_projections = {
\  "app/services/*.rb": {
\    "command": "service",
\    "test": [
\      "spec/services/{}_spec.rb"
\    ],
\  },
\  "app/serializers/*.rb": {
\    "command": "serializer",
\    "test": [
\      "spec/serializers/{}_spec.rb"
\    ],
\  },
\  "app/assets/javascripts/templates/*.hamlc": {
\    "command": "template",
\    "alternate": [
\      "app/assets/javascripts/views/{}.coffee"
\    ],
\  },
\  "app/assets/javascripts/collections/*.coffee": {
\    "command": "collection",
\    "alternate": [
\      "app/assets/javascripts/models/{singular}.coffee"
\    ],
\  },
\  "app/assets/javascripts/models/*.coffee": {
\    "command": "mmodel",
\    "alternate": [
\      "app/assets/javascripts/collections/{plural}.coffee"
\    ],
\  },
\  "app/assets/javascripts/views/*.coffee": {
\    "command": "vview",
\    "alternate": [
\      "app/assets/javascripts/templates/{}.hamlc"
\    ],
\  },
\  "app/assets/javascripts/components/*.coffee.cjsx": {
\    "command": "component"
\  }
\}

" Configure JSX syntax highlighting
let g:jsx_ext_required = 0

" Configure fugitive
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>ga :Gwrite<CR>
nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gd :Git! diff<CR>
nnoremap <Leader>gdc :Git! diff --cached<CR>

" Configure UltiSnips
let g:UltiSnipsExpandTrigger="<Leader><tab>"

" View a gem's info on rubygems.org
function! Gem()
  let gem_name = a:0

  if gem_name == ""
    let gem_name = expand("<cword>")
  end

  let url = "https://rubygems.org/gems/" . gem_name
  let cmd = "xdg-open " . url

  call system(cmd)
endfunction
command! Gem call Gem()
