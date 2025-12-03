# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source Omarchy defaults
source ~/.local/share/omarchy/default/bash/rc

# Launch nushell for interactive sessions
if command -v nu &> /dev/null; then
  exec nu
fi
