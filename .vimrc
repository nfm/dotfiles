" Vundle required config
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Bundles
Bundle 'gmarik/vundle'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-eunuch'
Bundle 'tpope/vim-speeddating'
Bundle 'tpope/vim-bundler'
Bundle 'kchmck/vim-coffee-script'
Bundle 'matchit.zip'
Bundle 'mru.vim'
Bundle 'kana/vim-textobj-user'
Bundle 'nelstrom/vim-textobj-rubyblock'
Bundle 'lunaru/vim-less'
Bundle 'vim-ruby/vim-ruby'
Bundle 'rking/ag.vim'
Bundle 'AutoTag'
Bundle 'majutsushi/tagbar'
Bundle 'scrooloose/nerdtree'
Bundle 'jpalardy/vim-slime'
Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdcommenter'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'altercation/vim-colors-solarized'
Bundle 'vim-scripts/YankRing.vim'
Bundle 'airblade/vim-gitgutter'
Bundle 'kien/ctrlp.vim'
Bundle 'mattn/gist-vim'
Bundle 'mattn/emmet-vim'
Bundle 'rcmdnk/vim-markdown'
Bundle 'valloric/YouCompleteMe'
Bundle 'mtscout6/vim-cjsx'

set nocompatible
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
\      "spec/services/%s_spec.rb"
\    ],
\  },
\  "app/serializers/*.rb": {
\    "command": "serializer",
\    "test": [
\      "spec/serializers/%s_spec.rb"
\    ],
\  },
\  "app/assets/javascripts/templates/*.hamlc": {
\    "command": "template",
\    "alternate": [
\      "app/assets/javascripts/views/%s.coffee"
\    ],
\  },
\  "app/assets/javascripts/collections/*.coffee": {
\    "command": "collection",
\    "alternate": [
\      "app/assets/javascripts/models/%i.coffee"
\    ],
\  },
\  "app/assets/javascripts/models/*.coffee": {
\    "command": "mmodel",
\    "alternate": [
\      "app/assets/javascripts/collections/%p.coffee"
\    ],
\  },
\  "app/assets/javascripts/views/*.coffee": {
\    "command": "vview",
\    "alternate": [
\      "app/assets/javascripts/templates/%s.hamlc"
\    ],
\  },
\  "app/assets/javascripts/components/*.coffee": {
\    "command": "component"
\  }
\}

" Configure fugitive
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>ga :Gwrite<CR>
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gd :Git! diff<CR>
nnoremap <Leader>gdc :Git! diff --cached<CR>

" Configure vim-markdown
let g:vim_markdown_folding_disabled=1

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
