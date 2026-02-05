#!/bin/zsh
# For conditionals, check "13.3 Conditional Substrings in Prompts" at:
# http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html

# With Zinit:
# zinit ice src"simple_theme.zsh"
# zinit light $ZDOTDIR/themes
# autoload -U colors && colors

# Define colors
if [[ "$TERM" == 'linux' ]]; then
  # For 16 colors, basic font.
  writable_dir=6       # cyan
  non_writable_dir=6   # cyan
  root_color=1         # red
  user_color=9
  prompt_color=6       # cyan
  error_color=1        # red
  lock=''
  prompt_char=">"      # Last character of prompt.
  vicmd_char="N"       # Use in vi cmd mode instead of above prompt char.
else
  # For 256 colors and font with symbols.
  writable_dir=43      # cyan
  # local writable_dir=82      # green
  non_writable_dir=33  # blue
  root_color=160       # red
  user_color=37
  prompt_color=42      # light green
  error_color=9        # red
  bg_jobs_color=cyan
  vicmd_color=blue
  lock=''             # Non-writable dir symbol
  prompt_char="$"
  # prompt_char="❯"
  vicmd_char="N"
fi

vicmd_char="%F{$vicmd_color}$vicmd_char%{$reset_color%}"

main_cursor="\e[5 q"   # Blinking beam
vicmd_cursor="\e[2 q"  # Steady block

# http://stackoverflow.com/questions/30985436/
# https://bbs.archlinux.org/viewtopic.php?id=95078
# http://unix.stackexchange.com/questions/115009/

# Executed every time the line editor is started to read a new line of input.
zle-line-init () {
  # zle -K viins
  printf $main_cursor
}
zle -N zle-line-init

# Executed every time the keymap changes, i.e. the special parameter KEYMAP is set
# to a different value, while the line editor is active. Initialising the keymap
# when the line editor starts does not cause the widget to be called.
function zle-keymap-select {
  zle reset-prompt
  if [[ $KEYMAP == vicmd ]]; then
      printf $vicmd_cursor
   else
    printf $main_cursor
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

if [[ $EUID == 0 ]]; then
  show_user=true
else
  show_user=false
fi

if [[ -n "$SSH_CONNECTION" ]]; then
  show_host=true
else
  show_host=false
fi

# Content of the prompt. # %F = foreground color.
function print_prompt() {
  if [[ $show_user == true ]]; then
    # If we are root, use different color.
    # Conditionals:  %(x.true-text.false-text) .
    # x=! : true if the shell is running with privileges.
    print -n "%(!.%{%F{$root_color}%}.%{%F{$user_color}%})$USER%f"
    [[ $show_host == false ]] && print -n " in "
  fi

  if [[ $show_host == true ]]; then
    print -n "%F{$user_color}@%m"
  fi

  [[ show_user == true || show_host == true ]] && print -n ":"

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
  # print -n "${${KEYMAP/vicmd/$vicmd_char}/(main|viins)/$prompt_char}%f "

  case $KEYMAP in
    vicmd)  print -n "$vicmd_char"  ;;
    *)      print -n "$prompt_char" ;;
  esac

  print -n "%f "  # End text coloring and add space.
}

prompt_precmd() {
  # Add empty line before prompt.
  echo
  PROMPT='%{%f%b%k%}$(print_prompt)'
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
