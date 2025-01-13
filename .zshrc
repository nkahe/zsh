#!/bin/zsh

# If not running interactively
[[ $- != *i* ]] && return

# provide a simple prompt till the proper loads.
PS1="%~ ❯ "

# If change directory name, delete old cache in $ZINIT_HOME/snippets
snippets_dir="$ZDOTDIR/snippets"
plugins_dir="$ZDOTDIR/plugins"
fpath+=("$ZDOTDIR/completions")

# Measure Zsh setup startup time.
file="$snippets_dir/startup-time.zsh"
[[ -f "$file" ]] && source "$file"

#ZSH_DISABLE_COMPFIX=true

# Show how fast Zsh loaded.
autoload -Uz add-zsh-hook
add-zsh-hook precmd show-elapsed-time

# Uncomment to profile speed.
#zmodload zsh/zprof

# Reset to default key bindings. Needs to be before any key binding changes.
bindkey -d

# Load Zinit - Zsh plugin manager. https://github.com/zdharma-continuum/zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
source "$ZINIT_HOME/bin/zinit.zsh"

ZINIT[ZCOMPDUMP_PATH]="${ZSH_CACHE_DIR:-$ZDOTDIR}/zcompdump"

# Fzf: "If you use vi mode on bash, you need to add set -o vi before source

# Set the key mapping style to 'emacs' or 'vi'.
zstyle ':prezto:module:editor' key-bindings 'vi'

# ~/.fzf.bash in your .bashrc, so that it correctly sets up key bindings
# for vi mode."
zstyle -s ':prezto:module:editor' key-bindings 'key_bindings'
if [[ "$key_bindings" == vi ]]; then
  set -o vi
fi

# Source plugin definitions
for file in $plugins_dir/*.zsh; do
 source "$file"
done

#  zinit ice multisrc"*.{zsh,sh}" lucid
#  zinit light $ZDOTDIR
#
#  zinit ice multisrc"*.zsh" lucid
#  zinit light $snippets_dir

# Using 'zinit snippet' command can cause issues with cache when files are changed.
for file in $ZDOTDIR/*.zsh $ZDOTDIR/aliases.sh $snippets_dir/*.zsh
do
  # Bindings have loaded earlier.
  # [[ $file == *bindings.zsh ]] && continue
  #source "$file"
  #zinit snippet "$file"
  source "$file"
done
# source "$ZDOTDIR/bindings.zsh"

# Normally is executed when loading syntax highlighting.
if [[ $HOST == raspberry* ]]; then
  zicompinit
fi

# zinit cdreplay -q
# -q is for quiet; actually run all the `compdef's saved before 'compinit`
# call (`compinit' declares the `compdef' function, so it cannot be used until
# `compinit` is ran; zinit solves this via intercepting the `compdef'-calls
# and storing them for later use with `zinit cdreplay')

if [[ $UID == 0 ]]; then
  echo "\nBy the Power of Grayskull, you are a root!"
  # If not launched inside NeoVim
  # elif which fortune &>/dev/null && [[ -z "$NVIM_LISTEN_ADDRESS" ]] ; then
  #   echo
  #   fortune
fi

# Uncomment to show speed profiling stats.
#zprof
