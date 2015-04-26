" Vundle required config
set nocompatible
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
Plugin 'kchmck/vim-coffee-script'
Plugin 'matchit.zip'
Plugin 'kana/vim-textobj-user'
Plugin 'nelstrom/vim-textobj-rubyblock'
Plugin 'vim-ruby/vim-ruby'
Plugin 'rking/ag.vim'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdtree'
Plugin 'jpalardy/vim-slime'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdcommenter'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'altercation/vim-colors-solarized'
Plugin 'airblade/vim-gitgutter'
Plugin 'kien/ctrlp.vim'
Plugin 'valloric/YouCompleteMe'
Plugin 'mtscout6/vim-cjsx'
call vundle#end()

set history=10000
syntax on
" Show unfinished commands in the status line
set showcmd
" Show line/column position of cursor in the status line
set ruler
" Fix slow O inserts after hitting ESC
set timeout timeoutlen=1000 ttimeoutlen=100

" Set up colors
" Make colors work with TERM=xterm
set t_Co=256
" Use solarized
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

" Disable arrow keys
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

" Shortcut to toggle Tagbar plugin
nmap <F8> :TagbarToggle<CR> 

" Make Y behave like other capitals
map Y y$

" Make typing : easier
nnoremap ; :

" Make saving easier
nnoremap <Leader>w :w<CR>

" Clear the search buffer when hitting return
nnoremap <Leader>n :nohlsearch<CR>

" Toggle paste mode
set pastetoggle=<Leader>p

" Close tabs quicker
nnoremap <Leader>q :close<CR>

" Shortcuts for tags
nnoremap <Leader>tt :tag
nnoremap <Leader>tn :tnext<CR>
nnoremap <Leader>tp :tprevious<CR>

" Configure wildcard expansion
set wildmenu
set wildignore+=*/tmp

" Search for word under cursor using ag
nnoremap K :Ag!<CR>
"\b<C-R><C-W>\b"<CR>:cw<CR>

" Configure vim-slime
let g:slime_target = "tmux"
let g:slime_paste_file = tempname()

" Configure syntastic
let g:syntastic_mode_map = { 'mode': 'active', 'active_filetypes': ['ruby', 'coffee'], 'passive_filetypes': ['sass'] }
let g:syntastic_auto_loc_list=1

" Configure YankRing
let g:yankring_history_dir = '$HOME/.vim'

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

" Configure fugitive
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>ga :Gwrite<CR>
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gd :Git! diff<CR>
nnoremap <Leader>gdc :Git! diff --cached<CR>

" Configure ycm
let g:ycm_collect_identifiers_from_tags_files = 1

" Look for tags in gems.tags file too
set tags+=gems.tags

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
