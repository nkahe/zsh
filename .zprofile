#!/bin/zsh
# Executes commands at login shells pre-zshrc, e.g. at system startup.
# /etc/zprofile gets executed before this
# NOTE: settings in /etc/zshrc override these.

# Don't put anything that outputs something here. Can break things
# like ssh and scp.

[[ -f $HOME/.profile ]] && source $HOME/.profile

# Ignore saving these to history file.
export HISTORY_IGNORE="(cd -|cd ..|ls|ll|la|pwd|exit|history|trfi*|tren*)"

# Used by OMZ plugins like last-working-dir and completions.
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ ! -d "$ZSH_CACHE_DIR" ]] && mkdir -p "$ZSH_CACHE_DIR"
