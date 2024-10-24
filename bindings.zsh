#echo "bindings test running"

WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

zmodload zsh/terminfo
typeset -gA key_info

# Only some terminals supports Ctrl-Backspace
key_info=(
  'Alt-Up'        '^[[1;3A'
  'Alt-Left'      '^[[1;3D'
  'Alt-Right'     '^[[1;3C'
  'Ctrl'          '\C-'
  'Ctrl-Backspace'  '^[[127;5u'
  'Ctrl-Delete'   '^[[3;5~'
  'Ctrl-Left'     '\e[1;5D \e[5D \e\e[D \eOd'
  'Ctrl-Right'    '\e[1;5C \e[5C \e\e[C \eOc'
  'Ctrl-PageUp'   '\e[5;5~'
  'Ctrl-PageDown' '\e[6;5~'
  'Alt'           '^['
  'Esc'          '\e'
  'Meta'         '\M-'
  'Backspace'    "^?"
  'Delete'       "^[[3~"
  'F1'           "$terminfo[kf1]"
  'F2'           "$terminfo[kf2]"
  'F3'           "$terminfo[kf3]"
  'F4'           "$terminfo[kf4]"
  'F5'           "$terminfo[kf5]"
  'F6'           "$terminfo[kf6]"
  'F7'           "$terminfo[kf7]"
  'F8'           "$terminfo[kf8]"
  'F9'           "$terminfo[kf9]"
  'F10'          "$terminfo[kf10]"
  'F11'          "$terminfo[kf11]"
  'F12'          "$terminfo[kf12]"
  'Insert'       "$terminfo[kich1]"
  'Home'         "$terminfo[khome]"
  'PageUp'       "$terminfo[kpp]"
  'End'          "$terminfo[kend]"
  'PageDown'     "$terminfo[knp]"
  'Up'           "$terminfo[kcuu1]"
  'Left'         "$terminfo[kcub1]"
  'Down'         "$terminfo[kcud1]"
  'Right'        "$terminfo[kcuf1]"
  'BackTab'      "$terminfo[kcbt]"
  "Shift-Tab"    '^[[Z'
)



if [[ "$OSTYPE" == "darwin"* ]]; then
  key_info[Opt-left]='^[^[[D'
  key_info[Opt-right]='^[^[[C'
fi

# Set empty $key values to an invalid UTF-8 sequence to induce silent
# bindkey failure.
for key in "${(k)key_info[@]}"; do
  if [[ -z "$key_info[$key]" ]]; then
    key_info[$key]='�'
  fi
done

# Allow command line editing in an external editor.
autoload -Uz edit-command-line
zle -N edit-command-line

# Runs bindkey but for all of the keymaps. Running it with no arguments will
# print out the mappings for all of the keymaps.
function bindkey-all {
  local keymap=''
  for keymap in $(bindkey -l); do
    [[ "$#" -eq 0 ]] && printf "#### %s\n" "${keymap}" 1>&2
    bindkey -M "${keymap}" "$@"
  done
}

#
# Functions overrides
# These override default Zsh functions.

# Reset the prompt based on the current context and
# the ps-context option.
function zle-reset-prompt {
  if zstyle -t ':prezto:module:editor' ps-context; then
    # If we aren't within one of the specified contexts, then we want to reset
    # the prompt with the appropriate editor_info[keymap] if there is one.
    if [[ $CONTEXT != (select|cont) ]]; then
      zle reset-prompt
      zle -R
    fi
  else
    zle reset-prompt
    zle -R
  fi
}
zle -N zle-reset-prompt

# Enables terminal application mode and updates editor information.
function zle-line-init {
  # The terminal must be in application mode when ZLE is active for $terminfo
  # values to be valid.
  if (( $+terminfo[smkx] )); then
    # Enable terminal application mode.
    echoti smkx
  fi
}
zle -N zle-line-init

# Disables terminal application mode
function zle-line-finish {
  # The terminal must be in application mode when ZLE is active for $terminfo
  # values to be valid.
  if (( $+terminfo[rmkx] )); then
    # Disable terminal application mode.
    echoti rmkx
  fi
}
zle -N zle-line-finish

# Show ls
_runcmdpushinput_ls () {
  # Set the buffer to 'ls' and accept the line
  BUFFER="ls"
  zle accept-line
}
zle -N _runcmdpushinput_ls

# Fast directory changing

function cd {
  BACK_HISTORY=$PWD:$BACK_HISTORY
  FORWARD_HISTORY=""
  builtin cd "$@"
}

function cd_previous_dir {
  DIR=${BACK_HISTORY%%:*}
  if [[ -d "$DIR" ]]; then
    BACK_HISTORY=${BACK_HISTORY#*:}
    FORWARD_HISTORY=$PWD:$FORWARD_HISTORY
    builtin cd "$DIR"
  fi
}

function cd_forward_dir {
  DIR=${FORWARD_HISTORY%%:*}
  if [[ -d "$DIR" ]]; then
    FORWARD_HISTORY=${FORWARD_HISTORY#*:}
    BACK_HISTORY=$PWD:$BACK_HISTORY
    builtin cd "$DIR"
  fi
}

# Reset to default key bindings.
bindkey -d

#
# Emacs Key Bindings
#

# Ctrl-Left / -Right move word left or right.
for key in "$key_info[Esc]"{B,b} "${(s: :)key_info[Ctrl-Left]}" \
  "${key_info[Esc]}${key_info[Left]}"
  bindkey -M emacs "$key" emacs-backward-word

for key in "$key_info[Esc]"{F,f} "${(s: :)key_info[Ctrl-Right]}" \
  "${key_info[Esc]}${key_info[Right]}"
  bindkey -M emacs "$key" emacs-forward-word

if [[ "$OSTYPE" == "darwin"* ]]; then
  bindkey "$key_info[Opt-right]" forward-word
  bindkey "$key_info[Opt-left]" backward-word
fi

# Kill to the beginning of the line.
for key in "$key_info[Esc]"{K,k}
  bindkey -M emacs "$key" backward-kill-line

bindkey -e "$key_info[Alt]l" _runcmdpushinput_ls

# Command insertion.
bindkey -s "$key_info[F12]" 'source bindings.zsh\n'
bindkey -s "$key_info[Alt-Right]" 'cd_forward_dir\n'
bindkey -s "$key_info[Alt-Left]" 'cd_previous_dir\n'
bindkey -s "$key_info[Alt-Up]" 'cd ..\n'

#
# Vi Key Bindings
#

#
# Emacs and Vi Key Bindings
#

# All modes
for keymap in 'emacs' 'viins' 'vicmd'; do
  bindkey -M "$keymap" "$key_info[Delete]" delete-char
  bindkey -M "$keymap" "$key_info[Home]" beginning-of-line
  bindkey -M "$keymap" "$key_info[End]" end-of-line
  bindkey -M "$keymap" "$key_info[Backspace]" backward-delete-char
  bindkey -M "$keymap" "$key_info[Ctrl-Backspace]" backward-delete-word
  bindkey -M "$keymap" "$key_info[Ctrl-Delete]" delete-word
done

# Keybinds for emacs and vi insert mode
for keymap in 'emacs' 'viins'; do
  bindkey -M "$keymap" "$key_info[Ctrl]l" clear-screen
  bindkey -M "$keymap" "$key_info[Insert]" overwrite-mode
  bindkey -M "$keymap" "$key_info[Left]" backward-char
  bindkey -M "$keymap" "$key_info[Right]" forward-char

  # Expand history on space.
  bindkey -M "$keymap" ' ' magic-space

  # Bind Shift + Tab to go to the previous menu item.
  bindkey -M "$keymap" "$key_info[BackTab]" reverse-menu-complete
  bindkey -M "$keymap" "$key_info[Shift-Tab]" reverse-menu-complete

done

# Set the default keymap
bindkey -e

unset key{,map,_bindings}
