#!/bin/zsh
# Needs to be named .sh or doesn't work in KDE Plasma.
# Executes commands at *login* shells pre-zshrc, e.g. at system startup.
# /etc/zprofile gets executed before this
# ! settings in /etc/zshrc override these.

# Initialization file. DE should set run this file at startup. Don't put
# anything that outputs something here. Can break things like ssh and scp.
# KDE Plasma: link to ~/.config/plasma-workspace/env

# LESS_TERMCAP_* variables are defined in Environment -Prezto -snippet.

export OLLAMA_MODELS=/home/ollama/models

export WINEPREFIX=$HOME/hdd/wine 

# Check if command exists.
has() {
  if command -v "$@" &> /dev/null; then
    return 0
  else
    return 1
  fi
}

# No read access to others by default.
[[ $EUID != 0 ]] && umask 027

# Doesn't work when sourcing here.
# file="$HOME/.config/shells/profile/ls_colors.sh"
# [[ -e $file ]] && source "$file"

# Run anacron as user. Note: doesn't start a daemon.
if has anacron && [[ $EUID != 0 ]]; then
  tabfile=$HOME/.config/anacrontab
  spooldir=$HOME/.local/spool/anacron
  if [[ -e "$tabfile" && -d "$spooldir" ]]; then
    /usr/sbin/anacron -s -t "$tabfile" -S "$spooldir"
  fi
fi

if has xbindkeys && ! pgrep xbindkeys &>/dev/null; then
  file="$HOME/.config/xbindkeysrc"
  if [[ -f $file ]] && ! pgrep wayland &>/dev/null; then
    xbindkeys -f "$file"
  fi
fi

if pgrep wayland &>/dev/null; then
	export MOZ_ENABLE_WAYLAND=1
fi

cachedir="${XDG_CACHE_HOME:-$HOME/.cache}"

export CHEAT_USE_FZF=true

# FZF by default starts in fullscreen mode, but you can make it start below the cursor with --height option.
export FZF_DEFAULT_OPTS='--height 40%'

# export FZF_ALT_C_COMMAND='^[d'


# Dasha
# export JAVA_HOME="/usr/lib64/jvm/java-1.8.0-openjdk"
# export VUFIND_HOME="/usr/local/dasha"
# export VUFIND_LOCAL_DIR="/usr/local/dasha/local"
# export SOLR_PORT=8083

# Set xterm to use 256 color mode if it already isn't.
[[ $TERM = (xterm|xterm-color) ]] && export TERM=xterm-256color

# If language settings are missing fix them.

##### Locale settings #####

# First set this lang to all locales.
export LANG="fi_FI.UTF-8"

# Character Type. Determines the locale category for character handling functions.
# Needs to be here.
export LC_CTYPE=$LANG

# Language of applications
export LC_MESSAGES="en_US.UTF-8"

# E:llä koitin laittaa oikea teema käyttöön qt-ohjelmille. Piti näemmä laittaa vielä
# enlightenmentin asetuksista. Xfce:llä ei qt5ct valitti, että on variable asetettu väärin.
# [[ $XDG_SESSION_DESKTOP != KDE ]] && export QT_QPA_PLATFORMTHEME="qt5ct"

# If you want to use DRI2.
# export LIBGL_DRI3_DISABLE=1

export AUDIOPLAYER="xdg-open"

# FIXME: ei toiminut, kun ei ajeta zshrc:stä käsin.
if has micro; then
  editor="micro"
elif has nvim; then
  editor="nvim"
elif has vim; then
  editor="vim"
else
  editor="nano"
fi

export EDITOR=$editor
export VISUAL=$editor

# In some distros like openSUSE this is defined in /etc/zshrc so this doesn't
# work but must be changed there.
export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}"/zsh/history

export HISTORY_IGNORE="(ls|ll|la|pwd|exit|history|cd -|cd ..)"

if has feh; then
  export IMAGEVIEWER='feh'
fi
if has zathura; then
  export PDFVIEWER='zathura'
fi

# if has most; then
  # export PAGER='most'
#else
  export PAGER='less'
  if [[ -f ${XDG_CONFIG_HOME:-${HOME}/.config}/lesskey ]]; then
    local configfile="--lesskey-file ${XDG_CONFIG_HOME:-${HOME}/.config}/lesskey"
  else
    local configfile=''
  fi
  export LESS="--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS $configfile"
  export LESSHISTFILE="$cachedir/.less_history"
  if [[ ! -f "$LESSHISTFILE" ]]; then
    if [[ ! -d "$cachedir" ]]; then
      mkdir -p "$cachedir"
    fi
    :>"$LESSHISTFILE"
  fi
#fi

# Open man pages in Vim/NeoVim. Needs fixing.
# export MANPAGER="$EDITOR -c 'set filetype=man' -"

if has bat; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  # It might also be necessary to set MANROFFOPT="-c" if you experience formatting problems.
  export MANROFFOPT="-c"
  if [[ $OSTYPE == 'darwin'* ]]; then
   export BAT_THEME='Monokai Extended'
  fi
fi

# .NET
# export DOTNET_CLI_TELEMETRY_OPTOUT=true

export GREP_COLOR='mt=1;32'

export GEM_HOME="$HOME/.local/rubygems"
[[ -d $GEM_HOME ]] && export PATH="$PATH:$GEM_HOME/bin"

# ---- User added programs and scripts ---------------

# if has kwallet-query &>/dev/null && has keepassxc &>/dev/null; then
#   kwallet-query -f '' -r '' kdewallet | keepassxc --pw-stdin $HOME/linux/passwd.kdbx
# fi

# GnuPG
# export GNUPGHOME=

# LibreOffice, use gtk.
# export SAL_USE_VCLPLUGIN=gtk

if has task; then
  # Task warrior
  export TASKRC="~/.config/taskrc"
  export TASKDATA="~/MegaSync/task"
fi

# export TLDR_COLOR_BLANK="cyan"
# export TLDR_COLOR_NAME="cyan"
# export TLDR_COLOR_DESCRIPTION="cyan"
# export TLDR_COLOR_EXAMPLE="green"
# export TLDR_COLOR_COMMAND="red"
# export TLDR_COLOR_PARAMETER="cyan"
# export TLDR_CACHE_ENABLED=1
# export TLDR_CACHE_MAX_AGE=720

# Don't populate ~ with historyfile. Ei toimi susella, kun määritellään
# uudestaan /etc/zshrc. on sen sijaan määritelty zshrc:ssä.
# export HISTFILE=$HOME/.local/share/.zsh_history

# Linux utility to configure modifier keys to act as other keys when pressed

# https://github.com/alols/xcape
# if has xcape &>/dev/null && [[ $TERM != linux ]]; then
  # if pgrep "xcape" ; then
  # fi
  # This is done in DE's settings so no need.
  # make CapsLock behave like Ctrl:
  # setxkbmap -option ctrl:nocaps
  # case "$HOST" in
  # HTPC
  # "linux-3vlk" || "hppro" ) xcape -e 'Caps_Lock=Escape' ;;
  # Desktop
  # "linux-iawx" )
    # setxkbmap -option "ctrl:nocaps"
    # xcape -e 'Control_L=Escape'
    # ;;
  # esac
# fi

# NPM: no annoying messages about new versions (package manager handles it).
if has npm; then
  export NO_UPDATE_NOTIFIER
fi

export WGETRC=${XDG_CONFIG_HOME:-$HOME/.config}/wgetrc

# Used by OMZ plugins like last-working-dir and completions.
export ZSH_CACHE_DIR="$cachedir/zsh"

[[ ! -d "$ZSH_CACHE_DIR" ]] && mkdir -p "$ZSH_CACHE_DIR"

# Note: ~/.local/bin is for npm and pip among others.
[[ -d $home/bin ]] && export PATH="$PATH:$HOME/bin:$HOME/.local/bin"

# Siirryin käyttämään ~/dotfiles/init_scripts, joka DE:stä käsin ajetaan.
#
# Device-specific settings here.

[[ -f "$ZDOTDIR/.zprofile.priv" ]] && source "$ZDOTDIR/.zprofile.priv"
