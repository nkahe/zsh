#!/bin/zsh
# Zsh's Vim-mode keybindings
# Huom! Älä bindaa Alt-[muu kuin alarivi/erikoisnäppäin] mihinkään tärkeään.
# Irssi vim-mode:ssa niillä vaihdetaan kanavaa.

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

# -a, -M vicmd = vim Normal mode
# -v, -M viins = vim Insert Mode

# You can send keypresses by: bindkey -as 'C' 'cc'

# Start in Vim Insert -mode.
bindkey -v

bindkey -M vicmd '/' fzf-history-widget
# bindkey -M vicmd '/' history-substring-search-down
bindkey -M vicmd '?' history-incremental-search-backward

# Misc
bindkey -a ' ' vi-insert
# bindkey '^G' what-cursor-position
bindkey -a u undo
bindkey -v ' ' magic-space
bindkey -v '^[h' run-help
bindkey -a '^[h' run-help

# Editing
bindkey -a '^?' backward-delete-char    # Backspace
bindkey -v "\e[3~" vi-delete-char       # Del
bindkey -a "\e[3~" vi-delete-char
bindkey -a 'daw' delete-word
bindkey "^[m" copy-prev-shell-word


# Moving in CLI
bindkey -v '^[[1;5C' vi-forward-word    # C-Oikea.
bindkey -a '^[[1;5C' vi-forward-word
bindkey -v '^[[1;5D' vi-backward-word   # C-Vasen.
bindkey -a '^[[1;5D' vi-backward-word

bindkey -v '^[[H' vi-beginning-of-line  # Home
bindkey -a '^[[H' vi-beginning-of-line
bindkey -v '^[[F' vi-end-of-line        # End
bindkey -a '^[[F' vi-end-of-line

# For nordic keyboard.
bindkey -a 'ö' vi-end-of-line
# bindkey -a 'j' vi-backward-char
#bindkey -a 'p' vi-put-after
#bindkey -a 'y' vi-yank

# Make some common Emacs bindings work too.
bindkey -v '^a' beginning-of-line
bindkey -v '^e' end-of-line
bindkey -v "^k" kill-line
bindkey -v "^u" kill-whole-line

# Deleting

# Ctrl-Backspace
# Pitää Yakuaken/konsolen asetuksia muuttaa ennen kuin voi käyttää:
# GUI: Profiles > Näppäimistö > Default (tai mitä käytätkään)
# CLI: Kopioi /usr/share/kde4/apps/konsole/default.keytab (tai mitä käytätkään)
# > ~/.kde/share/apps/konsole ja editoi tiedostoa.
#
# Muutokset:
# - key Backspace
# + key Backspace-Shift-Control : "\x7f"
# + key Backspace-Shift+Control : "\E[9;3~"
#
bindkey -a "\e[9;3~" vi-backward-kill-word
bindkey -v "\e[9;3~" vi-backward-kill-word

bindkey -a "\e[3;5~" kill-word
bindkey -v "\e[3;5~" kill-word

# Make basckspace work properly.
bindkey "^?" backward-delete-char

# Alt-I: History. Yritys tehdä
# bindkey -as 'q:' 'history^M'
# Vim-mäinen.
bindkey -a 'gg' beginning-of-buffer-or-history
bindkey -a 'g~' vi-oper-swap-case
# bindkey -a 'i' up-history
# bindkey -a 'G' end-of-buffer-or-history  # Tämän korvasin fzf-bindauksella
# bindkey -a 'k' down-history

# Vim Clipboard Integration. This is using xclip but the same could be
# accomplished with xsel, pbcopy/pbpaste, etc.
if [[ -n $DISPLAY ]] && command -v xclip &> /dev/null; then
  function cutbuffer() {
    zle .$WIDGET
    echo $CUTBUFFER | xclip
  }
  zle_cut_widgets=(
    # En halua, että menee leikepöydälle, jos poistetaan yksi merkki.
    # vi-backward-delete-char
    # vi-delete-char
    vi-change
    vi-change-eol
    vi-change-whole-line
    vi-delete       # d-kirjaimen toiminto
    vi-kill-eol
    vi-substitute
    vi-yank
    vi-yank-eol
  )
  for widget in $zle_cut_widgets
  do
    zle -N $widget cutbuffer
done

  function putbuffer() {
    zle copy-region-as-kill "$(xclip -o)"
    zle .$WIDGET
  }
  zle_put_widgets=(
    vi-put-after
    vi-put-before
  )
  for widget in $zle_put_widgets
  do
    zle -N $widget putbuffer
  done
fi
