# history-substring-search. Type in any part of any previously  entered
# command and press the UP and DOWN arrow keys to cycle through the matching
# commands. https://github.com/zsh-users/zsh-history-substring-search.

function define_keybindings() {
  # Define key bindings for up and down actions
  local -A keys=([up]='\eOA' [up2]='^[[A' [down]='\eOB' [down2]='^[[B')

  # Bind the up and down keys for each keymap in the array
  for keymap in emacs vicmd viins; do
    for action in up down; do
      bindkey -M "$keymap" "${keys[$action]}" "history-substring-search-${action}"
      bindkey -M "$keymap" "${keys[${action}2]}" "history-substring-search-${action}"
    done
  done

  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down
}

# Alternative method to define bindkeys. Works the same.
function alt_define_keybindings() {
  # Define key bindings for up/down history search
  local -A keys=(
    [up]='\eOA' [up2]='^[[A' [down]='\eOB' [down2]='^[[B'
  )

  # Bind keys for emacs and viins keymaps
  for keymap in emacs viins; do
    bindkey -M "$keymap" "${keys[up]}" history-substring-search-up
    bindkey -M "$keymap" "${keys[up2]}" history-substring-search-up
    bindkey -M "$keymap" "${keys[down]}" history-substring-search-down
    bindkey -M "$keymap" "${keys[down2]}" history-substring-search-down
  done

  # Bind keys for vicmd keymap (vi command mode)
  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down
}

# ! "wait" time has to be bigger than syntax-highlighting has!
#   bindkey -M vicmd "?" history-incremental-pattern-search-backward
#   bindkey -M vicmd "/" history-incremental-pattern-search-forward
zinit ice wait"1" lucid atload"_zsh_highlight" atinit"define_keybindings"
zinit load zsh-users/zsh-history-substring-search
