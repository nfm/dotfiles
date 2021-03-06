# Sourced in interactive shells.
# Should contain commands to set up aliases, functions, options, key bindings, etc.

# Load profiling module to benchmark time taken to initialize zsh
# zmodload zsh/zprof

source ~/.zsh/aliases
source ~/.zsh/functions.zsh

umask 077

export EDITOR=/usr/bin/nvim
export BROWSER=/usr/bin/firefox

# Solarized
eval `dircolors ~/.zsh/dircolors/solarized.ansi-dark`

# Initialize chruby
source $HOME/.local/share/chruby/chruby.sh
chruby ruby-2.7.1

# Initialize nvm
if [[ -e ~/.nvm/nvm.sh ]]
then
  source ~/.nvm/nvm.sh
  nvm alias default 10.13.0 >> /dev/null
fi

# Run `nvm use` automatically in directories with a .nvmrc file
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Ruby performance improvements
export RUBY_GC_HEAP_INIT_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1.25
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_HEAP_FREE_MIN=600000
export RUBY_GC_HEAP_FREE_SLOTS=600000

# Ubuntu bionic and below has libjemalloc1, cosmic and above has libjemalloc2
LIBJEMALLOC1="/usr/lib/x86_64-linux-gnu/libjemalloc.so.1"
LIBJEMALLOC2="/usr/lib/x86_64-linux-gnu/libjemalloc.so.2"

if [[ -e ${LIBJEMALLOC1} ]]
then
  export LD_PRELOAD=${LIBJEMALLOC1}
elif [[ -e ${LIBJEMALLOC2} ]]
then
  export LD_PRELOAD=${LIBJEMALLOC2}
fi

# Temporary fix for rustc segfaulting
unset LD_PRELOAD

# Set up the prompt
autoload -U colors && colors
source ~/.zsh/prompt.zsh

# Keep 100000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt histignorealldups
setopt incappendhistory 
setopt extendedhistory

# Use modern completion system
autoload -Uz compinit

# Include some custom completions (sourced from https://github.com/zsh-users/zsh-completions/)
fpath=($HOME/.zsh/completions $fpath)

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

# Use vi mode
bindkey -v

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Bind keys for history searching
bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins '^F' history-incremental-pattern-search-forward
bindkey -M viins '^P' up-history
bindkey -M viins '^N' down-history
bindkey -M viins '^[.' insert-last-word
bindkey "^[OA" up-line-or-beginning-search # Up
bindkey "^[OB" down-line-or-beginning-search # Down

# Use C-x C-e to edit the current command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

bindkey -M viins 'jj' vi-cmd-mode

# Call zprof to display profiler output
# zprof
