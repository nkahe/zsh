# vim: ft=bash
# Executes commands at login shells pre-zshrc, e.g. at system startup.
# /etc/zprofile gets executed before this.
# settings in /etc/zshrc can override these.
#
# Don't put anything that outputs text here. Can break things like ssh and scp.
#
# NOTE: No Zsh-only syntax. This file is linked to ~/.profile and is sourced
# from Bash too.

# If terminal is set to xterm, set 256 color mode.
if [[ $TERM == xterm || $TERM == xterm-color ]]; then
  export TERM=xterm-256color
fi

# Path
[[ -d $HOME/bin ]] && export PATH="$PATH:$HOME/bin"
[[ -d $HOME/.local/bin ]] && export PATH="$PATH:$HOME/.local/bin"
[[ -d $HOME/scripts ]] && export PATH="$PATH:$HOME/scripts"

export GEM_HOME="$HOME/.local/rubygems"
[[ -d $GEM_HOME ]] && export PATH="$PATH:$GEM_HOME/bin"


# Check if a command exists.
function has() {
  command -v "$@" &> /dev/null
}

# Ignore saving these to history file.
export HISTORY_IGNORE="(cd -|cd ..|ls|ll|la|pwd|exit|history|trfi*|tren*)"

# Default text editor
if has nvim; then
  export NVIM_APPNAME=nvim-custom
  EDITOR="nvim"
elif has micro; then
  EDITOR="micro"
else
  EDITOR="nano"
fi

export $EDITOR
export SYSTEMD_EDITOR=$EDITOR
export VISUAL=$EDITOR

# has qimgv && export IMAGEVIEWER='qimgv'
# has zathura && export PDFVIEWER='zathura'
# export AUDIOPLAYER="xdg-open"

# moor pager is installed as zinit -plugin so it's executable is not
# available when this file is sourced.
# if has moar; then
  export PAGER='moor'
  export MOOR='-style github-dark'
# elif has most; then
#   export PAGER='most'
# else
#   export PAGER='less'
# fi

if has nvimpager; then
  export MANPAGER='nvimpager'
fi

if has bat; then
  # export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  # It might be necessary to set MANROFFOPT="-c" if  experience formatting problems.
  export MANROFFOPT="-c"
  export BAT_THEME='Visual Studio Dark+'
fi

export GREP_COLORS='ms=01;36:mc=01;31:sl=37:cx=01;33:fn=34:ln=94:bn=32:se=36'

# Less  ------------------------------------------------------------------------

# Termcap is defined in PZT::modules--environment

if [[ -f ${XDG_CONFIG_HOME:-${HOME}/.config}/lesskey ]]; then
  configfile="--lesskey-file ${XDG_CONFIG_HOME:-${HOME}/.config}/lesskey"
else
  configfile=''
fi

export LESS="--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen \
  --RAW-CONTROL-CHARS $configfile"
cachedir="${XDG_CACHE_HOME:-$HOME/.cache}"
export LESSHISTFILE="$cachedir/.less_history"

if [[ ! -f "$LESSHISTFILE" ]]; then
  if [[ ! -d "$cachedir" ]]; then
    mkdir -p "$cachedir"
  fi
  :>"$LESSHISTFILE"
fi
unset cachedir configfile

# Other application ------------------------------------------------------------

# NPM: no annoying messages about new versions (package manager handles it).
if has npm; then
  export NO_UPDATE_NOTIFIER
fi

# dir="$HOME/.local/state"
# [[ ! -d "$dir" ]] && mkdir -p "$dir"
# file="$dir/.node_repl_history"
# export NODE_REPL_HISTORY="$file"
# unset dir file

has cheat && export CHEAT_USE_FZF=true

# FZF by default starts in fullscreen mode, but you can make it start below the cursor
# with --height option.
has fzf && export FZF_DEFAULT_OPTS='--height 40%'

# export FZF_ALT_C_COMMAND='^[d'

# TLDR
if has tldr; then
  # tldr installed with pip. https://pypi.org/project/tldr/
  export TLDR_COLOR_BLANK="cyan"
  export TLDR_COLOR_NAME="green"
  export TLDR_COLOR_DESCRIPTION="cyan"
  # Example tells what command does.
  export TLDR_COLOR_EXAMPLE="white"
  export TLDR_COLOR_COMMAND="blue"
  export TLDR_COLOR_PARAMETER="cyan"
  export TLDR_CACHE_ENABLED=1
  export TLDR_CACHE_MAX_AGE=720
fi

# Linux utility to configure modifier keys to act as other keys when presse

if has wget; then
  export WGETRC=${XDG_CONFIG_HOME:-$HOME/.config}/wgetrc
fi
