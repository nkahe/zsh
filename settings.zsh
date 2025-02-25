#!/bin/zsh

# These settings are an addition or overwrite to Prezto settings.
# Completion settings are at completion.zsh

# Named directories
hash -d cheat="$HOME/Nextcloud/cheat" config="$HOME/.config" \
  share="$HOME/.local/share" zsh="$ZDOTDIR"

# Turn beeping off
if [[ "$TERM" == (linux|dump) ]]; then
  setterm -blength 0
elif [[ -z "$SSH_CONNECTION" ]] && command -v xset &>/dev/null; then
  xset -b
fi

# Don't set AUTO_NAME_DIRS. Makes prompt path to be expanded to variable names.

# if argument to cd is the name of a parameter whose value is a valid
# directory, it will become the current directory
setopt cdablevarS

setopt pushdminus

# I don't have options that don't preserve the right history order, such as
# hist_expire_dups_first and setopt hist_ignore_dups, because plugin
unsetopt HIST_EXPIRE_DUPS_FIRST
unsetopt HIST_IGNORE_ALL_DUPS

# Append lines instead of overwriting the history file.
setopt append_history
