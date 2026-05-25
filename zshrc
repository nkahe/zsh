#!/bin/zsh

# If not running interactively
[[ $- != *i* ]] && return

# Set ZSH_BENCH to show startup benchmark.
if [[ -n $ZSH_BENCH ]]; then
  zmodload zsh/zprof
fi

# Measure configuration load time.
source $ZDOTDIR/lib/startup-time.zsh
# Show how fast Zsh loaded.

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

# ZSH_DISABLE_COMPFIX=true

# Reset to default key bindings. Needs to be before any key binding changes.
bindkey -d

zstyle ':antidote:bundle' use-friendly-names 'yes'

# Source antidote
ad_path="${XDG_DATA_HOME:-${HOME}/.local/share}/antidote"
if [[ -f $ad_path/antidote.zsh ]]; then
  source $ad_path/antidote.zsh
else
  # first, run this from an interactive zsh terminal session:
  git clone --depth=1 https://github.com/mattmc3/antidote.git $ad_path
  source $ad_path/antidote.zsh
fi

zstyle ':prezto:environment:termcap' color

# Set the file to save the history in when an interactive shell exits.
# zstyle ':prezto:module:history' histfile "${ZDOTDIR:-$HOME}/.zsh_history"

# Set the maximum number of events stored in the internal history list.
zstyle ':prezto:module:history' histsize 99999

# Set the maximum number of history events to save in the history file.
zstyle ':prezto:module:history' savehist 99999

# Source before plugins. zsh-sage didn't work properly if this was sourced after.
source $ZDOTDIR/completion.zsh

# Load plugins.
antidote load ${ZDOTDIR:-~}/zsh_plugins.txt

# Prompt
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
else
  # Light custom backup -theme.
  file=$ZDOTDIR/themes/simple_theme.zsh
  [[ -f $file ]] && source $file
fi

# Add fuzzy-finder/fzf Zsh integration while using Zvm-Vi-Mode.
# Fast Fuzzy Finder for Command-Line Search
# https://github.com/fuzzy-finder/fzf
(( $+commands[fzf] )) && zvm_after_init_commands+=("source <(fzf --zsh)")
# (( $+commands[fzf] )) && source <(fzf --zsh)

# ajeetdsouza/zoxide: A smarter cd command.
# https://github.com/ajeetdsouza/zoxide
(( $+commands[zoxide] )) && zsh-defer eval "$(zoxide init zsh)"

# Source snippets.
# NOTE: If changing content of files sourced with zinit, it needs to be
# updated with 'zinit update (name)' because files are compiled and cached.

# Files to be sourced.
files=(
  aliases.sh
  bindings.zsh
  settings.zsh
  zsh-aliases.zsh
  *.local.zsh(N)
  lib/navi.zsh
)

for f in $files; do
  [[ -r $ZDOTDIR/$f ]] && source $ZDOTDIR/$f
done

# (N) = suppress "no matches" errors.
for f in $ZDOTDIR/snippets/*.zsh(N) $ZDOTDIR/snippets/*.sh(N); do
  source "$f"
done

# Files deferred later than others.
for f in $ZDOTDIR/later/*.zsh(N); do
  # source "$file"
  zsh-defer -t 2 source "$f"
done

# Binary is installed with ubi.
if (( $+commands[zsh-patina] )); then
  eval "$(zsh-patina activate)"
fi

# Show benchmark scores.
if [[ -n $ZSH_BENCH ]]; then
  zprof | head -n 40
fi
