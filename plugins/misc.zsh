# Load misc plugins

# NOTE: Don't rename executables if want completion to work.

# Raspille:
# https://github.com/starship/starship/releases/latest/download/starship-arm-unknown-linux-musleabihf.tar.gz

# "lucid" = no non-error output. "light" = no plugin tracking or reporting.
# "wait" = parallel "turbo-mode".
# ! if "mv" executable completions probably don't work.

# bashmount: Tool to mount and unmount removable media from the command-line
# https://github.com/jamielinux/bashmount
zinit ice wait"2" lucid as"program" pick"bashmount"
zinit load jamielinux/bashmount

# Command Help. Extract help text from builtin commands and man pages.
# https://github.com/learnbyexample/command_help
zinit ice wait"1" lucid as"program" pick"ch"
zinit load learnbyexample/command_help

# rvaiya/keyd: A key remapping daemon for linux.
# https://github.com/rvaiya/keyd
# make'!...' -> run make before atclone & atpull
zinit ice wait"2" lucid as"program" make'!' pick"bin/keyd" \
  atclone"sudo systemctl enable --now keyd" \
  cp"keyd.1.gz -> $HOME/.local/man/man1"
    zinit load rvaiya/keyd

zinit ice wait lucid from"github-rel" as"program" bpick"*linux-amd64" mv"moar* -> moar"
zinit load walles/moar

# Yet Another Dotfiles Manager - yadm https://yadm.io
zinit ice wait"2" lucid as"program" has"git" pick"yadm" \
  cp"yadm.1 -> $HOME/.local/man/man1" atpull'%atclone'
zinit load TheLocehiliosan/yadm

# zsh-system-clipboard: System clipboard key bindings for Zsh Line Editor with vi mode.
# https://github.com/kutsan/zsh-system-clipboard
# Use Wayland + clipboard.
# Doesn't work itself if Zsh-Vi-Mode is also used. Instead own bindings are
# bindings are used.
zinit load kutsan/zsh-system-clipboard

# jeffreytse/zsh-vi-mode: A better and friendly vi(vim) mode plugin for ZSH.
# https://github.com/jeffreytse/zsh-vi-mode
zstyle -s ':prezto:module:editor' key-bindings 'key_bindings'
zinit ice depth=1 if"[[ $key_bindings == vi ]]"
zinit light jeffreytse/zsh-vi-mode

# Ensure zsh-vi-mode initializes after other keybindings
export ZVM_INIT_MODE=sourcing
zvm_after_init() {
#   bindkey -v
  # bindkey -M vicmd 'c' zsh-system-clipboard-vicmd-vi-change
  # bindkey -M vicmd 'ccc' zsh-system-clipboard-vicmd-vi-change-whole-line
  # bindkey -M vicmd 'cc$' zsh-system-clipboard-vicmd-vi-change-eol
  bindkey -M vicmd 'cd' zsh-system-clipboard-vicmd-vi-delete
#   bindkey -M vicmd 'cd$' zsh-system-clipboard-vicmd-kill-eol
  bindkey -M vicmd 'cp' zsh-system-clipboard-vicmd-vi-put-after
  bindkey -M vicmd 'cP' zsh-system-clipboard-vicmd-vi-put-before
  bindkey -M vicmd 'cy' zsh-system-clipboard-vicmd-vi-yank
  # bindkey -M vicmd 'cY' zsh-system-clipboard-vicmd-vi-yank-eol
  # bindkey -M vicmd 'cyy' zsh-system-clipboard-vicmd-vi-yank-whole-line
}

function zvm_after_lazy_keybindings() {
  if ! zle -l edit-command-line; then
    autoload -Uz edit-command-line
    zle -N edit-command-line
  fi

  for keymap in 'emacs' 'viins' 'vicmd'; do
    # Search previous character.
    zvm_bindkey $keymap "^X^B" vi-find-prev-char

    # Match bracket.
    zvm_bindkey $keymap "^X^]" vi-match-bracket

    # Edit command in an external editor.
    zvm_bindkey $keymap "^X^E" edit-command-line
  done
}

# zsh-completions: Additional completion definitions for Zsh.
# https://github.com/clarketm/zsh-completions
zinit light clarketm/zsh-completions

# Alternative to previous.
# zsh-completions: Additional completion definitions for Zsh.
# https://github.com/zsh-users/zsh-completions
#zinit light zsh-users/zsh-completions

# xiny: Simple command line tool for unit conversions
# https://github.com/bcicen/xiny
zinit ice wait"2" lucid from"github-rel" as"program" bpick"*linux*" mv"xiny* -> xiny"
zinit load bcicen/xiny

# compfiles=("$ZSH_CACHE_DIR"/zcompdump(Nm-20))
# # alkup: compfiles=(${ZDOTDIR:-$HOME}/.zcompdump(Nm-20))
# if (( $#compfiles )); then
#   compinit -i -C -d "$compfiles"
#   echo "[zshrc]" running compinit -i -C "$compfiles"
# else
#   compinit -i -d "$compfiles"
#   echo "[zshrc]" running compinit -i -d "$compfiles"
# fi
# unset compfiles
