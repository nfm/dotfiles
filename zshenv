# Sourced on all invocations of a shell, unless -f option is set.
# Should contain commands to set the command search path, plus other important environment variables.
# Should not contain commands that produce output or assume the shell is attached to a tty.

# Don't call compinit automatically, we call this manually in .zshrc and calling it twice is unnecessarily slow.
skip_global_compinit=1

export PATH="$HOME/.local/bin:$HOME/.bin:$HOME/.yarn/bin:$HOME/.cargo/bin:$PATH"
