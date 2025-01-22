# Settings and definitions for selected modules from Prezto -configuration
# framework. Forked Prezto modules are in their own snippets files.

# Directory

# Sets directory options and defines directory aliases.
zinit snippet PZT::modules/directory/init.zsh


# Environment

# Sets general shell options and defines termcap variables.
zstyle ':prezto:environment:termcap' color
zinit snippet PZT::modules/environment/init.zsh


# History

# In some distros like openSUSE this is defined in /etc/zshrc so this doesn't
# work but must be changed there.
zstyle ':prezto:module:history' histfile "${XDG_STATE_HOME:-$HOME/.local/state}"/zsh/history
export HISTORY_IGNORE="(ls|ll|la|pwd|exit|history|cd -|cd ..)"

# Set the file to save the history in when an interactive shell exits.
# zstyle ':prezto:module:history' histfile "${ZDOTDIR:-$HOME}/.zsh_history"

# Set the maximum  number  of  events  stored  in  the  internal history list.
zstyle ':prezto:module:history' histsize 99999

# Set the maximum number of history events to save in the history file.
zstyle ':prezto:module:history' savehist 99999

# Sets history options and defines history aliases.
zinit snippet PZT::modules/history/init.zsh

# Other

# zinit ice wait"2" lucid
# zinit snippet OMZP::extract

