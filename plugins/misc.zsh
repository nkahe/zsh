# Load misc plugins

# Don't rename executables if want completion to work.
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

# Tungsten - WolframAlpha CLI. https://github.com/ASzc/tungsten
zinit ice wait"2" lucid as"program" pick"tungsten.sh" atload"alias ask=tungsten.sh"
zinit load ASzc/tungsten

# A CLI tool that scrapes Google search results and SERPs that provides
# instant and concise answers. https://github.com/Bugswriter/tuxi
zinit ice wait"2" as"program" pick"tuxi" lucid
zinit load Bugswriter/tuxi

# jeffreytse/zsh-vi-mode: A better and friendly vi(vim) mode plugin for ZSH.
# https://github.com/jeffreytse/zsh-vi-mode
zstyle -s ':prezto:module:editor' key-bindings 'key_bindings'
zinit ice depth=1 if"[[ $key_bindings == vi ]]"
zinit light jeffreytse/zsh-vi-mode

# agkozak/zsh-z: Jump quickly to directories that you have visited "frecently."
# A native Zsh port of z.sh. https://github.com/agkozak/zsh-z
#local file="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/z"
#zinit ice wait lucid atinit"export _Z_DATA=$file" atclone"touch $file"
#zinit load agkozak/zsh-z

# zsh-completions: Additional completion definitions for Zsh.
# https://github.com/zsh-users/zsh-completions
#zinit light zsh-users/zsh-completions

# zsh-completions: Additional completion definitions for Zsh.
# https://github.com/clarketm/zsh-completions
zinit light clarketm/zsh-completions

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

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi
