#
# Sets key bindings.
#
# Forked from Prezto editor module.

# Treat these characters as part of a word.
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

# ! Ctrl-b on monesti tmuxille.

# Display bindings defined here and in some plugins.
function lsbind() {
  (echo; echo -e "
  \nDefaults
  Ctrl-A    Move to start of line
  Ctrl-B    Move to end of line
  Ctrl-U    Kill whole line
  Ctrl-K    Kill to end of line
  Alt-K     Kill to beginning of line
  Ctrl-C    Kill the process
  Ctrl-D    End-of-line
  Ctrl-L    Clear screen
  Ctrl-N    Select next menu item
  Ctrl-P    Select previous menu item
  Ctrl-Q    Push the line to stack
  Ctrl-Z    Suspend the process
  Alt-G     Get the line from stack
  Alt-F     Move a word forward
  Alt-B     Move a word backward

  Extras
  ↑ | ↓     History substring search
  Ctrl-B    Show these bindings
  Alt-<nbr> Paste <nbr> parameters of last command.
  Alt-↑     cd ..
  Alt- ← | ->   cd previous / next dir.
  Alt-C     Fzf cd
  Alt-E     Expand command path
  Alt-L     ls
  Alt-M     Duplicate previous word
  Alt-V     Toggle vi / emacs mode.
  Ctrl-G    Fzf cd to any dir
  Ctrl-R    Fzf search history
  Ctrl-T    Fzf select file
  Ctrl-I    Complete in middle of a word
  Ctrl-Z    2. press to continue process in background
  F12       Source binding settings
  Ctrl-BS   Kill previous word
  Ctrl-Del  Kill next word
  Ctrl-Space    Expand aliases
  Ctrl- ← | ->  Move to previous / next word
  C-x C-s   Prepend line with sudo" | column)

  zle reset-prompt
}

zle -N lsbind

#   Alt-K     Describe key briefly.
#   Alt-E     Edit command line in text editor.
#   Alt-C     Copy command line to X-clipboard.
#   Alt-Y     Redo
#   Alt-Z     Undo

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

# Inserts 'sudo ' at the beginning of the line.
function prepend-sudo {
  if [[ "$BUFFER" != su(do|)\ * ]]; then
    BUFFER="sudo $BUFFER"
    (( CURSOR += 5 ))
  fi
}
zle -N prepend-sudo

# Expand aliases
function glob-alias {
  zle _expand_alias
  zle expand-word
  zle magic-space
}
zle -N glob-alias

# Toggle the comment character at the start of the line. This is meant to work
# around a buggy implementation of pound-insert in zsh.
#
# This is currently only used for the emacs keys because vi-pound-insert has
# been reported to work properly.
function pound-toggle {
  if [[ "$BUFFER" = '#'* ]]; then
    # Because of an oddity in how zsh handles the cursor when the buffer size
    # changes, we need to make this check before we modify the buffer and let
    # zsh handle moving the cursor back if it's past the end of the line.
    if [[ $CURSOR != $#BUFFER ]]; then
      (( CURSOR -= 1 ))
    fi
    BUFFER="${BUFFER:1}"
  else
    BUFFER="#$BUFFER"
    (( CURSOR += 1 ))
  fi
}
zle -N pound-toggle

#
# End of Prezto functions.
#

# Show ls
_runcmdpushinput_ls () {
  # Set the buffer to 'ls' and accept the line
  BUFFER="ls"
  zle accept-line
}
zle -N _runcmdpushinput_ls

# Fast directory changing

function cd() {
  BACK_HISTORY=$PWD:$BACK_HISTORY
  FORWARD_HISTORY=""
  builtin cd "$@"
}

function cd-previous-dir() {
  DIR=${BACK_HISTORY%%:*}
  if [[ -d "$DIR" ]]; then
    BACK_HISTORY=${BACK_HISTORY#*:}
    FORWARD_HISTORY=$PWD:$FORWARD_HISTORY
    builtin cd "$DIR"
  fi
}

function cd-previous-dir() {
  DIR=${FORWARD_HISTORY%%:*}
  if [[ -d "$DIR" ]]; then
    FORWARD_HISTORY=${FORWARD_HISTORY#*:}
    BACK_HISTORY=$PWD:$BACK_HISTORY
    builtin cd "$DIR"
  fi
}

vi-mode() {
  set -o vi
  echo "Vi-mode on"
  zle reset-prompt
}

emacs-mode() {
  set -o emacs
  echo "Emacs mode on"
  zle reset-prompt
}

zle -N vi-mode
zle -N emacs-mode

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
  bindkey "$key_info[Opt-left]"  backward-word
fi

# Kill to the beginning of the line.
for key in "$key_info[Esc]"{K,k}
  bindkey -M emacs "$key" backward-kill-line

# Change to Vi-mode
bindkey -e "$key_info[Alt]v" vi-mode

# Search previous character.
bindkey -M emacs "$key_info[Ctrl]X$key_info[Ctrl]B" vi-find-prev-char

# Match bracket.
bindkey -M emacs "$key_info[Ctrl]X$key_info[Ctrl]]" vi-match-bracket

# Edit command in an external editor.
bindkey -M emacs "$key_info[Ctrl]X$key_info[Ctrl]E" edit-command-line

# Command insertion.
bindkey -s "$key_info[F12]" 'source $ZDOTDIR/plugins/termsupport.zsh\n'
# bindkey -s "$key_info[F12]" 'source $ZDOTDIR/bindings.zsh\n'
bindkey -s "$key_info[Alt-Right]" 'cd-forward-dir\n'
bindkey -s "$key_info[Alt-Left]" 'cd-previous-dir\n'
bindkey -s "$key_info[Alt-Up]" 'cd ..\n'


# Toggle comment at the start of the line. Note that we use pound-toggle which
# is similar to pount insert, but meant to work around some issues that were
# being seen in iTerm.
# Keybind Ctrl-7
bindkey -M emacs "$key_info[Ctrl]_" pound-toggle

#
# Vi Key Bindings
#

# Undo/Redo
bindkey -M vicmd "u" undo
bindkey -M viins "$key_info[Ctrl]_" undo
bindkey -M vicmd "$key_info[Ctrl]R" redo
#
# if (( $+widgets[history-incremental-pattern-search-backward] )); then
#   bindkey -M vicmd "?" history-incremental-pattern-search-backward
#   bindkey -M vicmd "/" history-incremental-pattern-search-forward
# else
#   bindkey -M vicmd "?" history-incremental-search-backward
#   bindkey -M vicmd "/" history-incremental-search-forward
# fi

# Keybinds for all vi keymaps
for keymap in viins vicmd; do
  # Ctrl + Left and Ctrl + Right bindings to forward/backward word
  for key in "${(s: :)key_info[Ctrl-Left]}"
    bindkey -M "$keymap" "$key" vi-backward-word
  for key in "${(s: :)key_info[Ctrl-Right]}"
    bindkey -M "$keymap" "$key" vi-forward-word
  bindkey -M "$keymap" "$key_info[Alt]v" emacs-mode
done

#
# Emacs and Vi Key Bindings
#

# history-substring-search bindings are defined in zshrc since they need be
# defined when the plugin loads which is after this file.

# Unbound keys in vicmd and viins mode will cause really odd things to happen
# such as the casing of all the characters you have typed changing or other
# undefined things. In emacs mode they just insert a tilde, but bind these keys
# in the main keymap to a noop op so if there is no keybind in the users mode
# it will fall back and do nothing.
function _prezto-zle-noop {  ; }
zle -N _prezto-zle-noop
local -a unbound_keys
unbound_keys=(
  "${key_info[F1]}"
  "${key_info[F2]}"
  "${key_info[F3]}"
  "${key_info[F4]}"
  "${key_info[F5]}"
  "${key_info[F6]}"
  "${key_info[F7]}"
  "${key_info[F8]}"
  "${key_info[F9]}"
  "${key_info[F10]}"
  "${key_info[F11]}"
  "${key_info[PageUp]}"
  "${key_info[PageDown]}"
  "${key_info[ControlPageUp]}"
  "${key_info[ControlPageDown]}"
)

#"${key_info[F12]}"

for keymap in $unbound_keys; do
  bindkey -M viins "${keymap}" _prezto-zle-noop
  bindkey -M vicmd "${keymap}" _prezto-zle-noop
done

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

  bindkey -M "$keymap" "$key_info[Ctrl]l"  clear-screen
  bindkey -M "$keymap" "$key_info[Insert]" overwrite-mode
  bindkey -M "$keymap" "$key_info[Left]"   backward-char
  bindkey -M "$keymap" "$key_info[Right]"  forward-char

  # Expand history on space.
  bindkey -M "$keymap" ' ' magic-space

  # List bindings
  bindkey -M "$keymap" "$key_info[Ctrl]b" lsbind

  # Expand command name to full path.
  for key in "$key_info[Esc]"{E,e}
    bindkey -M "$keymap" "$key" expand-cmd-path

  # Duplicate the previous word.
  for key in "$key_info[Esc]"{M,m}
    bindkey -M "$keymap" "$key" copy-prev-shell-word

  # Use a more flexible push-line.
  for key in "$key_info[Ctrl]Q" "$key_info[Esc]"{q,Q}
    bindkey -M "$keymap" "$key" push-line-or-edit

  # Insert 'sudo ' at the beginning of the line.
  bindkey -M "$keymap" "$key_info[Ctrl]X$key_info[Ctrl]S" prepend-sudo

  # Bind Shift + Tab to go to the previous menu item.
  # Some different key-infos for these.
  for key in BackTab Shift-Tab
    bindkey -M "$keymap" "$key_info[$key]" reverse-menu-complete

  # Complete in the middle of word.
  bindkey -M "$keymap" "$key_info[Ctrl]I" expand-or-complete

  # control-space expands all aliases, including global
  bindkey -M "$keymap" "$key_info[Ctrl] " glob-alias

  # Execute ls
  bindkey -M "$keymap" "$key_info[Esc]l" _runcmdpushinput_ls
done


# Set the key layout.
zstyle -s ':prezto:module:editor' key-bindings 'key_bindings'
if [[ "$key_bindings" == (emacs|) ]]; then
  bindkey -e
elif [[ "$key_bindings" == vi ]]; then
  bindkey -v
else
  print "prezto: editor: invalid key bindings: $key_bindings" >&2
fi

unset key{,map,_bindings}
