#!/bin/zsh
# vim:ft=zsh ts=2 sw=2 sts=2
#
# Using colors:
# %F (%f) : Start (stop) using a different foreground colour
#
# For conditionals, check "13.3 Conditional Substrings in Prompts" at:
# http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html

# With Zinit:
# zinit ice src"oma_teema.zsh-theme"
# zinit light $ZDOTDIR/themes


# autoload -U colors && colors

# These should be in .zshrc or such.
default_user=''

# Define colors
if [[ "$TERM" == 'linux' ]]; then
  # For 16 colors, basic font.
  local writable_dir=2       # green
  local non_writable_dir=6   # cyan
  local root_color=1         # red
  local user_color=9
  local prompt_color=6       # cyan
  local error_color=1        # red
  local lock=''
else
  # For 256 colors and font with symbols.
  local writable_dir=82      # green
  local non_writable_dir=33  # blue
  local root_color=160       # red
  local user_color=37
  local prompt_color=42      # light green
  local error_color=9        # red
  local bg_jobs_color=cyan
  local lock=''             # Non-writable dir symbol
fi

# Text for different vimmodes.
# %F{$non_writable_dir}%~
vim_ins_mode="%F{28}Ins %{$reset_color%}"
vim_cmd_mode="%F{33}Nor %{$reset_color%}"
vim_mode=$vim_ins_mode

# Beam
ins_mode_cursor="\e[5 q"

# Block
cmd_mode_cursor="\e[1 q"

# Modal cursor color for vi's insert/normal modes.
##
# Other cursor options: cheat shell-cursors
# http://stackoverflow.com/questions/30985436/
# https://bbs.archlinux.org/viewtopic.php?id=95078
# http://unix.stackexchange.com/questions/115009/

# Default mode & cursor
zle-line-init () {
  zle -K viins
  # Colors are commented because they are set by zsh-syntax-highlighting -plugin
  #echo -ne "\033]12;Grey\007"
  #echo -n 'grayline1'
  # echo -ne "\033]12;Gray\007"
  printf $ins_mode_cursor

  # echo -ne "\033[4 q"
  #print 'did init' >/dev/pts/16
}

zle -N zle-line-init

# Change cursor based on vimmode
function zle-keymap-select {
  vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
  zle reset-prompt
  # Normal / Command mode
  if [[ $KEYMAP == vicmd ]]; then
    # If not run inside Tmux.
    if [[ -z $TMUX ]]; then
      # printf "\033]12;Green\007"
      printf $cmd_mode_cursor
    else
      # printf "\033Ptmux;\033\033]12;red\007\033\\"
      # printf "\033Ptmux;\033\033[1 q\033\\"
      printf $cmd_mode_cursor
    fi
  else
    # Insert mode
    if [[ -z $TMUX ]]; then
      # printf "\033]12;Grey\007"
      # Beam
      printf $ins_mode_cursor
      # Underscore
      # printf "\033[4 q"
    else
      # printf "\033Ptmux;\033\033]12;grey\007\033\\"
      # printf "\033Ptmux;\033\033[4 q\033\\"
      printf $ins_mode_cursor
    fi
  fi
  #print 'did select' >/dev/pts/16
}

zle -N zle-keymap-select

function zle-line-finish {
  vim_mode=$vim_ins_mode
}
zle -N zle-line-finish

# Fix a bug when you C-c in CMD mode and you'd be prompted with CMD mode
# indicator, while in fact you would be in INS mode Fixed by catching
# SIGINT (C-c), set vim_mode to INS and then repropagate the SIGINT, so if
# anything else depends on it, we will not break it.
function TRAPINT() {
  vim_mode=$vim_ins_mode
  return $(( 128 + $1 ))
}

# Content of the prompt
prompt() {
  # Username. Show if it's not the default.
  if [[ "$USER" != "$default_user" ]]; then
      # If we are root, use different color.
      # Conditionals:  %(x.true-text.false-text) .
      # x=! : true if the shell is running with privileges.
      print -n "%(!.%{%F{$root_color}%}root.%{%F{$user_color}%}"$USER")"
      local add_colon=true
  fi

  # Print host if we are on SSH.
  if [[ -n "$SSH_CONNECTION" ]]; then
      print -n "%F{$user_color}@%m"
      local add_colon=true
  fi

  # Print colon if either user or host was printed.
  [[ -n "$add_colon" ]] && print -n ":"

  # Vim-mode
  print -n "$vim_mode"

  # (%~) : Working dir. Use different color if it's writable by current user.
  if [[ ! -w "$PWD" ]]; then
      print -n "%F{$non_writable_dir}%~%f%F{$non_writable_dir} $lock "
  else
      print -n "%F{$writable_dir}%~ "
  fi

  # Background jobs. Print '&' and number of jobs if there's atleast 1 (%j1).
  # default prompt color.
  print -n "%1(j.%{%F{$bg_jobs_color}%}&%j .)"

  # Prompt sign. Use different color if previous command didn't exit with 0 (= ?).
  # Use '$' prompt sign for regular user, '#' for root (= !).
  print -n "%(?.%F{$prompt_color}.%F{$error_color})%(!.#.$)%f "
}

prompt_precmd() {
    echo
    PROMPT='%{%f%b%k%}$(prompt)'

    # Right-side prompt
    # RPROMPT='${vim_mode}'
}

autoload -Uz add-zsh-hook

# The prompt function will set these prompt_* options after the setup function
# returns. We need prompt_subst so we can safely run commands in the prompt
# without them being double expanded and we need prompt_percent to expand the
# common percent escape sequences.
prompt_opts=(cr subst percent)

# Borrowed from promptinit, sets the prompt options in case the theme was
# not initialized via promptinit.
setopt noprompt{bang,cr,percent,subst} "prompt${^prompt_opts[@]}"

add-zsh-hook precmd prompt_precmd
