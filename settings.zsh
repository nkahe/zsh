#!/bin/zsh
# $ZDOTDIR/settings.zsh. Different settings.
# Note: completion settings are at completion.zsh

Jobs() { # {{{

  # List jobs in the long format by default.
  setopt long_list_jobs

  # Treat single word simple commands without redirection as candidates for resumption of an existing job.
  setopt AUTO_RESUME

  # Report the status of background jobs immediately, rather than waiting until just before printing a prompt.
  setopt NOTIFY

  # Don't run all background jobs at a lower priority.
  unsetopt BG_NICE

  # Don't send the HUP (hang-up) signal to running jobs when the shell exits.
  unsetopt HUP

  # Dont't set: report the status of background and suspended jobs before exiting a shell with job control;
  # a second attempt to exit the shell will succeed.
  # NO_CHECK_JOBS is best used only in combination with NO_HUP, else such jobs will be killed automatically.
  unsetopt CHECK_JOBS

} #}}}
Directories() { # {{{

# cd -command searches from these. '.' first so it will search that first.
cdpath=(. "$HOME")

# Named directories
hash -d cheat="$HOME/linux/cheat" share="$HOME/.local/share" zsh="$ZDOTDIR"

# Don't set AUTO_NAME_DIRS. Makes prompt path to be expanded to variable names.

# If a command is issued that can’t be executed as a normal command,
# and the command is the name of a directory, perform the cd command to that directory.
setopt auto_cd

# if argument to cd is the name of a parameter whose value is a valid directory, it will become the current directory
setopt cdablevarS

# Make cd push the old directory onto the directory stack.
setopt auto_pushd

# Don’t push multiple copies of the same directory onto the directory stack.
setopt pushd_ignore_dups

# Do not print the directory stack after pushd or popd.
setopt pushd_silent

# Have pushd with no arguments act like ‘pushd ${HOME}’.
setopt pushd_to_home

setopt pushdminus

# Perform implicit tees or cats when multiple redirections are attempted.
setopt MULTIOS

} #}}}
History_settings() { # {{{

  # Big history
  HISTSIZE=10000
  SAVEHIST=10000

  # I don't have options that don't preserve the right history order, such as hist_expire_dups_first and
  # setopt hist_ignore_dups, because plugin 'Auto Suggest's optional strategy 'match_prev_cmd' don't work then.
  # See more at https://github.com/zsh-users/zsh-autosuggestions/blob/master/src/strategies/match_prev_cmd.zsh

  # Instead of overwriting the history file, instead it appends lines.
  setopt append_history

  # Perform textual history expansion, treating the character ‘!’ specially.
  # kts. cheat historian_korvaus.
  setopt bang_hist

  # Shares history across all sessions rather than waiting for a new shell
  # invocation to read the history file.
  setopt share_history

  # Remove command lines from the history list when the first character on the line is a space,
  # or when one of the expanded aliases contains a leading space.
  setopt hist_ignore_space

  # Whenever the user enters a line with history expansion, don’t execute the line directly;
  # instead, perform history expansion and reload the line into the editing buffer.
  setopt hist_verify

  # If a new command line being added to the history list duplicates an older one,
  # the older command is removed from the list (even if it is not the previous event).
  setopt HIST_IGNORE_ALL_DUPS

} # }}}
Main () { # {{{

  # No flow control so Ctrl-S/Q are usable.
  stty -ixon

  # if [[ "$TERM" != (linux|dump) ]] && [[ -z "$SSH_CONNECTION" ]]; then
    # Xorg: beeping off if we aren't in tty.
    # xset -b
  # Make Caps Lock new esc if config exists.
    # setxkbmap -option "caps:escape"
    #setxkbmap -option "caps:swapescape"
  # fi

  # Treat the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation, etc.
  # (An initial unquoted ‘~’ always produces named directory expansion.)
  setopt extended_glob

  # Allow comments even in interactive shells
  setopt INTERACTIVE_COMMENTS

  # FIXME Ei toiminut
  # For local there's already empty line before prompt.
  # if [[ -n $SSH_CONNECTION ]]; then
  #   precmd() { echo }
  # fi

  Directories
  Jobs
  History_settings
} # }}}
Main
