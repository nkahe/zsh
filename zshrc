#!/bin/zsh

# If not running interactively
[[ $- != *i* ]] && return

# Measure configuration load time.
# file="$snippets_dir/startup-time.zsh"
# [[ -f "$file" ]] && source "$file"
# unset file

zsh_start_time=$(date +%s%N)

# Define a precmd hook to run just before the prompt is displayed
function show-elapsed-time() {
  # Get the current time just before showing the prompt
  zsh_end_time=$(date +%s%N)

  # Calculate the time difference in milliseconds
  # Convert nanoseconds to milliseconds
  elapsed_time=$(( (zsh_end_time - zsh_start_time) / 1000000 ))

  echo "Config load time: ${elapsed_time} ms"

  add-zsh-hook -d precmd show-elapsed-time
}

# Show how fast Zsh loaded.
autoload -Uz add-zsh-hook
add-zsh-hook precmd show-elapsed-time

# Profile is loaded when starting login shell. Uncomment to temporarily
# source it for all interactive shells.
# source $ZDOTDIR/.zprofile

# Fzf: "If you use vi mode on bash, you need to add set -o vi before source
# bindkey -v should set it.

bindkey -v      # Uncomment for Vi-input mode
# set -o emacs  # Uncomment for Emacs-input mode.

print -n '\e[5 q'  # Set beam cursor from start.

# provide a simple prompt till the proper loads.
PS1="%~ ❯ "

fpath+=("$ZDOTDIR/completions")

#ZSH_DISABLE_COMPFIX=true

# Uncomment to profile speed.
# zmodload zsh/zprof

# Reset to default key bindings. Needs to be before any key binding changes.
bindkey -d

zstyle ':antidote:bundle' use-friendly-names 'yes'

# Source antidote
source "${XDG_DATA_HOME:-${HOME}/.local/share}/antidote/antidote.zsh"

zstyle ':prezto:environment:termcap' color

# Set the file to save the history in when an interactive shell exits.
# zstyle ':prezto:module:history' histfile "${ZDOTDIR:-$HOME}/.zsh_history"

# Set the maximum  number  of  events  stored  in  the  internal history list.
zstyle ':prezto:module:history' histsize 99999

# Set the maximum number of history events to save in the history file.
zstyle ':prezto:module:history' savehist 99999

# initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
antidote load ${ZDOTDIR:-~}/zsh_plugins.txt

# Prompt
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
else
  Light custom backup -theme.
  themefile=$ZDOTDIR/themes/simple_theme.zsh
  [[ -f $themefile ]] && source $themefile
fi

# fuzzy-finder/fzf: Fast Fuzzy Finder for Command-Line Search
# https://github.com/fuzzy-finder/fzf
(( $+commands[fzf] )) && source <(fzf --zsh)

# ajeetdsouza/zoxide: A smarter cd command.
# https://github.com/ajeetdsouza/zoxide
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# FIXME Command not found
# (( $+commands[eza] )) && compdef eza=ls

# Used by OMZ plugins like last-working-dir and completions.
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ ! -d "$ZSH_CACHE_DIR" ]] && mkdir -p "$ZSH_CACHE_DIR"

# Source snippets.
# NOTE: If changing content of files sourced with zinit, it needs to be
# updated with 'zinit update (name)' because files are compiled and cached.

for file in $ZDOTDIR/snippets/*.zsh $ZDOTDIR/snippets/*.sh; do
  source "$file"
done

# Defer sourcing of these files.
for file in $ZDOTDIR/later/*.zsh; do
  # source "$file"
  zsh-defer source "$file"
done

setopt nullglob       # unmatched globs expand to nothing

# Files to be sourced.
files=(
  aliases.sh
  bindings.zsh
  completion.zsh
  settings.zsh
  zsh-aliases.zsh
)

for f in $files; do
[[ -r $ZDOTDIR/$f ]] && source $ZDOTDIR/$f
done

# Any local files outside version control.
for f in $ZDOTDIR/*.local.zsh; do
  source $f
done

# Uncomment to show speed profiling stats.
# zprof
