#!/bin/zsh
# Key bindings. Plugin specific bindings are defined in .zshrc

# Key definitions --------------------------------------------------------------
declare -A key
alt="^["

key[up]='\eOA' key[up2]='^[[A' key[down]='\eOB' key[down2]='^[[B'
key[A-up]='^[[1;3A' key[A-left]='^[[1;3D' key[A-right]='^[[1;3C'
key[A-home]='^[[1;3H'
key[home]='^[[H'
key[end]='^[[F'
key[del]='^[[3~'
key[f12]='[24~'
key[BS]='^?'
key[C-BS]='^[[127;5u'
key[A-BS]="^[^?"
key[C-left]='^[[1;5D' key[C-right]='^[[1;5C'
key[C-del]='^[[3;5~'
key[S-tab]='^[[Z'

if [[ "$OSTYPE" == "darwin"* ]]; then
  key[Opt-left]='^[^[[D'
  key[Opt-right]='^[^[[C'
fi

# List bindings ----------------------------------------------------------------

# List bindings defined here and by plugins
function lsbind() {
  echo "\
  Binding   Command
------------------------------------------------------
  Alt-K     Describe key briefly.
  Alt-L     ls
  Alt-E     Edit command line in text editor.
  Alt-C     Copy command line to X-clipboard.
  Alt-M     Copy previous word.
  Alt-V     Paste from X-clipboard to command line.
  Alt-Y     Redo
  Alt-Z     Undo
  Alt-<nbr> Paste <nbr> parameters of last command.
  Alt-BS    Delete previous word.
  Alt-Home  cd ~
  (Alt--    cd -)
  Alt-↑     cd ..
  Alt- ← | ->   cd previous / next dir.
  Alt-D     Fzf cd
  ↑         History substring search up
  ↓         History substring search down
  Ctrl-G    Fzf change dir
  Ctrl-T    Fzf select file
  Ctrl-Z    Secod press continues job.
  C-Del     Delete word
  F12       Source settings."
}

# Misc -------------------------------------------------------------------------

# What code shortcut sends: Ctrl-V <shortcut> or
# (another way: 'cat -v'  showed wrong codes)
#
# ctrl: ^ tai \C-, Alt: \e or ^[

# Aloita emacs moodissa: bindkey -e,
# export KEYTIMEOUT=3   # Viive, kun odottaa että tuleeko lisää näppäimiä komentoon Vim-moodissa.

# Hyvä, niin voi käyttää aliaksia sudon kanssa:
# _expand_alias

# Check 'vim-bindaukset.zsh' for Vim-bindings.

# Edit command line in text editor (shortcut same as in Fish).
autoload -z edit-command-line
zle -N edit-command-line
bindkey "${alt}e" edit-command-line

# Edit command-line in editor

# Waits for keypress, then prints the function bound to the pressed key.
bindkey "${alt}k" describe-key-briefly

# Shortcut same as in Fish.
bindkey -s "${alt}l" 'ls^M'

# Copy & paste previous word
bindkey "${alt}m" copy-prev-shell-word

# Find file
if typeset -f fzfz-file-widget &> /dev/null; then
  bindkey '^G' fzfz-file-widget
fi
bindkey "${alt}d" fzf-cd-widget

# Go to the previous menu item.
bindkey "$key[S-tab]" reverse-menu-complete

bindkey "$key[f12]" load_personal_configs
zle -N load_personal_configs

function previous_command_hotkeys() {
  # Bang! Previous Command Hotkeys
  # print previous command but only the first nth arguments
  # Alt+1, Alt+2 ...etc
  bindkey -s '\e1' "!:0 \t"
  bindkey -s '\e2' "!:0-1 \t"
  bindkey -s '\e3' "!:0-2 \t"
  bindkey -s '\e4' "!:0-3 \t"
  bindkey -s '\e5' "!:0-4 \t"
  bindkey -s '\e`' "!:0- \t"     # all but the last word
}

bindkey "${alt}z" undo
bindkey "${alt}y" redo

previous_command_hotkeys

# Change directories -----------------------------------------------------------

bindkey -s "$key[A-up]" 'cd ..\n'

# Same shortcut as Firefox' Go to homepage.
bindkey -s "$key[A-home]" 'cd ~^M'

# These don't work fs used with Enhancd.
BACK_HISTORY="" FORWARD_HISTORY=""

function cd_previous_forward() {
  function cd {
    BACK_HISTORY=$PWD:$BACK_HISTORY
    FORWARD_HISTORY=""
    builtin cd "$@"
  }

  function cd_previous_dir {
    DIR=${BACK_HISTORY%%:*}
    if [[ -d "$DIR" ]]
    then
      BACK_HISTORY=${BACK_HISTORY#*:}
      FORWARD_HISTORY=$PWD:$FORWARD_HISTORY
      builtin cd "$DIR"
    fi
  }
  bindkey -s "$key[A-left]" 'cd_previous_dir\n'

  function cd_forward_dir {
    DIR=${FORWARD_HISTORY%%:*}
    if [[ -d "$DIR" ]]
    then
      FORWARD_HISTORY=${FORWARD_HISTORY#*:}
      BACK_HISTORY=$PWD:$BACK_HISTORY
      builtin cd "$DIR"
    fi
  }
  bindkey -s "$key[A-right]" 'cd_forward_dir\n'
}

cd_previous_forward

# Moving cursor ----------------------------------------------------------------

bindkey "$key[home]" beginning-of-line
bindkey "$key[end]" end-of-line

if [[ "$OSTYPE" == "darwin"* ]]; then
  bindkey "$key[Opt-right]" forward-word
  bindkey "$key[Opt-left]" backward-word
else
  bindkey "$key[C-right]" forward-word
  bindkey "$key[C-left]" backward-word
fi

# Deleting characters ----------------------------------------------------------

bindkey "$key[del]" delete-char

# Only some terminals use this sequence.
bindkey "$key[C-BS]" backward-delete-word

# Alt-backspace to delete backward word like in Emacs mode.
bindkey "$key[A-BS]" backward-kill-word

bindkey "$key[C-del]" delete-word

# Many terminals (like Terminator) send ^H with C-BS.
# Qterminal sends this with only backspace so doesn't work!

# bindkey '^H' backward-delete-word

# Clipboard --------------------------------------------------------------------

# Copy command line to X clipboard
function copy-to-xclip() {
    zle copy-region-as-kill
    print -rn -- $CUTBUFFER | xclip -selection clipboard -in
}
zle -N copy-to-xclip
bindkey "${alt}c" copy-to-xclip

# Paste from X clipboard to command line
function paste-xclip() {
    killring=("$CUTBUFFER" "${(@)killring[1,-2]}")
    CUTBUFFER=$(xclip -selection clipboard -out)
    zle yank
}
zle -N paste-xclip
bindkey "${alt}v" paste-xclip

# Do history expansion
bindkey ' ' magic-space
