# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

export PATH="$HOME/go/bin:$HOME/.local/bin:$PATH"

# Go module proxy - uses local Athens cache if running, falls back to public proxy
export GOPROXY=http://localhost:3000,https://proxy.golang.org,direct
