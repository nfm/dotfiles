source /etc/zsh/zshrc
source ~/.zsh/aliases
source ~/.zsh/functions

umask 077

export EDITOR=/usr/bin/vim

# Solarized
eval `dircolors ~/.zsh/dircolors/solarized.ansi-dark`

# PATH
export PATH="/usr/local/heroku/bin:$HOME/.local/bin:$HOME/.bin:$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Initialize nvm
source ~/.nvm/nvm.sh
nvm use 0.10.5 >> /dev/null

# Ruby performance improvements
export RUBY_HEAP_MIN_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1.25
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_HEAP_FREE_MIN=600000
export RUBY_FREE_MIN=600000
export LD_PRELOAD=/usr/lib/libtcmalloc_minimal.so.4

# Set up the prompt
autoload -U colors && colors
source ~/.zsh/prompt.zsh

setopt histignorealldups sharehistory

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt incappendhistory 
setopt sharehistory
setopt extendedhistory

# Use modern completion system
autoload -Uz compinit

# Include some custom completions (sourced from https://github.com/zsh-users/zsh-completions/)
fpath=($HOME/.zsh/completions/src $fpath)

compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Load up zmv
autoload zmv

# Bind keys for history searching
bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins '^F' history-incremental-pattern-search-forward

# Use C-x C-e to edit the current command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line
