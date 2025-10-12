#!/bin/zsh
# For conditionals, check "13.3 Conditional Substrings in Prompts" at:
# http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html

# With Zinit:
# zinit ice src"simple_theme.zsh"
# zinit light $ZDOTDIR/themes
# autoload -U colors && colors

# These should be in .zshrc or such.
default_user='henri'

# TODO: emacs mode support.

# Define colors
if [[ "$TERM" == 'linux' ]]; then
  # For 16 colors, basic font.
  local writable_dir=6       # cyan
  local non_writable_dir=6   # cyan
  local root_color=1         # red
  local user_color=9
  local prompt_color=6       # cyan
  local error_color=1        # red
  local lock=''
  local prompt_char=">"
  local vicmd_char="N"
else
  # For 256 colors and font with symbols.
  local writable_dir=43      # cyan
  # local writable_dir=82      # green
  local non_writable_dir=33  # blue
  local root_color=160       # red
  local user_color=37
  local prompt_color=42      # light green
  local error_color=9        # red
  local bg_jobs_color=cyan
  local vicmd_color=blue
  local lock=''             # Non-writable dir symbol
  local prompt_char="❯"
  local vicmd_char="N"
fi

vicmd_char="%F{$vicmd_color}$vicmd_char%{$reset_color%}"

# Blinking beam
viins_cursor="\e[5 q"

# Steady block
vicmd_cursor="\e[2 q"

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
  printf $viins_cursor
  # echo -ne "\033[4 q"
}
zle -N zle-line-init

# Change cursor depending on vi mode.
function zle-keymap-select {
  zle reset-prompt
  if [[ $KEYMAP == vicmd ]]; then  # Normal / Command mode
    if [[ -z $TMUX ]]; then        # If not run inside Tmux.
      # printf "\033]12;Green\007"
      printf $vicmd_cursor
    else
      # printf "\033Ptmux;\033\033]12;red\007\033\\"
      # printf "\033Ptmux;\033\033[1 q\033\\"
      printf $vicmd_cursor
    fi
  else
    if [[ -z $TMUX ]]; then
      # printf "\033]12;Grey\007"
    else
      # printf "\033Ptmux;\033\033]12;grey\007\033\\"
      # printf "\033Ptmux;\033\033[4 q\033\\"
    fi
    printf $viins_cursor
  fi
}
zle -N zle-keymap-select

# function zle-line-finish {
#   vim_mode=$vim_ins_mode
# }
# zle -N zle-line-finish

# Fix a bug when you C-c in CMD mode and you'd be prompted with CMD mode
# indicator, while in fact you would be in INS mode Fixed by catching
# SIGINT (C-c), set vim_mode to INS and then repropagate the SIGINT, so if
# anything else depends on it, we will not break it.
function TRAPINT() {
  return $(( 128 + $1 ))
}

# Content of the prompt
prompt() {
  # Show username if it's not the default.
  if [[ "$USER" != "$default_user" ]]; then
    # If we are root, use different color.
    # Conditionals:  %(x.true-text.false-text) .
    # x=! : true if the shell is running with privileges.
    # %F = foreground color.
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

  # (%~) : Working dir. Use different color if it's writable by current user.
  if [[ ! -w "$PWD" ]]; then
    print -n "%F{$non_writable_dir}%~%f%F{$non_writable_dir} $lock "
  else
    print -n "%F{$writable_dir}%~ "
  fi

  # Background jobs. Print '&' and number of jobs if there's atleast 1 (%j1).
  # default prompt color.
  print -n "%1(j.%{%F{$bg_jobs_color}%}&%j .)"

  # Prompt character. Use different color if previous command didn't exit with 0 (= ?).
  print -n "%(?.%F{$prompt_color}.%F{$error_color})"
  print -n "${${KEYMAP/vicmd/$vicmd_char}/(main|viins)/$prompt_char}%f "
}

prompt_precmd() {
  PROMPT='%{%f%b%k%}$(prompt)'
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
