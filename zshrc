#!/bin/zsh

# If not running interactively
[[ $- != *i* ]] && return

# Measure Zsh setup startup time.
file="$snippets_dir/startup-time.zsh"
[[ -f "$file" ]] && source "$file"
unset file

source $ZDOTDIR/.zprofile

# Set the key mapping style to either 'emacs' or 'vi'.
# Fzf: "If you use vi mode on bash, you need to add set -o vi before source
key_bindings=vi

# provide a simple prompt till the proper loads.
PS1="%~ ❯ "

# If change directory name, delete old cache in $ZINIT_HOME/snippets
snippets_dir="$ZDOTDIR/snippets"
plugins_dir="$ZDOTDIR/plugins"
fpath+=("$ZDOTDIR/completions")

#ZSH_DISABLE_COMPFIX=true

# Show how fast Zsh loaded.
autoload -Uz add-zsh-hook
add-zsh-hook precmd show-elapsed-time

# Uncomment to profile speed.
# zmodload zsh/zprof

# Reset to default key bindings. Needs to be before any key binding changes.
bindkey -d

# Load Zinit - Zsh plugin manager. Install if not present.
# https://github.com/zdharma-continuum/zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
if [ ! -d $ZINIT_HOME/bin/.git ]; then
  [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "$ZINIT_HOME/bin/zinit.zsh"

ZINIT[ZCOMPDUMP_PATH]="${ZSH_CACHE_DIR:-$ZDOTDIR}/zcompdump"

# Set so fzf correctly sets up key bindings for vi mode.
if [[ "$key_bindings" == vi ]]; then
  bindkey -v
else
  set -o emacs
  # Bindings are sourced from a Vi-Zsh-Mode's hook in plugins/misc.zsh if we
  # are using vi input mode.
  files+=(bindings.zsh)
fi

# Used by OMZ plugins like last-working-dir and completions.
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ ! -d "$ZSH_CACHE_DIR" ]] && mkdir -p "$ZSH_CACHE_DIR"


# Source Zinit plugin specs if Zinit is loaded.
if [[ -n $(functions zinit) ]]; then
  for file in $plugins_dir/*.zsh
  do
    source "$file"
  done
  unset file plugins_dir
else
  # Else use backup theme.
  file=$ZDOTDIR/themes/simple_theme.
  [[ -f $file ]] && source $file
  unset file
fi

# Source snippets.
# NOTE: If changing content of files sourced with zinit, it needs to be
# updated with 'zinit update (name)' because files are compiled and cached.
for file in $snippets_dir/*.zsh $snippets_dir/*.sh
do
  # source "$file"
  zinit ice id-as"$f"
  zinit snippet "$file"
done
unset file snippets_dir

 # zinit ice multisrc"*.zsh *.sh" lucid
 # zinit light $snippets_dir

setopt nullglob       # unmatched globs expand to nothing

# Files to be sourced.
files=(
  aliases.sh
  completion.zsh
  settings.zsh
  zsh-aliases.zsh
)

for f in $files; do
[[ -r $ZDOTDIR/$f ]] && source $ZDOTDIR/$f
  # If want to measure time taken:
  # zinit ice id-as"$f"
  # zinit snippet $ZDOTDIR/$f
done

# Any local files outside version control.
for f in $ZDOTDIR/*.local.zsh
do
  source $f
done

#  zinit ice multisrc"*.{zsh,sh}" lucid
#  zinit light $ZDOTDIR
#

# Normally is executed when loading syntax highlighting.
if [[ -n "$ID" && "$ID" == "raspbian" ]]; then
  zicompinit
fi

# zinit cdreplay -q
# -q is for quiet; actually run all the `compdef's saved before 'compinit`
# call (`compinit' declares the `compdef' function, so it cannot be used until
# `compinit` is ran; zinit solves this via intercepting the `compdef'-calls
# and storing them for later use with `zinit cdreplay')

# Uncomment to show speed profiling stats.
# zprof

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

if [[ "$key_bindings" == vi ]]; then
  bindkey -v
  # Set beam cursor.
  print -n '\e[5 q'
fi

