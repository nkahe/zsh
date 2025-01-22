#!/bin/zsh
# Place this file in home directory and rest of Zsh config files to directory below.

dir="$HOME/.config/zsh"
if [[ -f "$dir/.zshrc" || -f "$dir/zshrc" ]]; then
  export ZDOTDIR="$dir"
fi
unset dir
#skip_global_compinit=1
