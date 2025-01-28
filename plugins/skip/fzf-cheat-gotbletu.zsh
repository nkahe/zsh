#!/usr/bin/env bash
### Author          : gotbletu
### Name            : fzf_cheat
### Version         : 0.1
### Date            : 20190509
### Description     : fuzzy finder quickly copy code snippets from cheat to clipboard
### Depends On      : bash  grep  cheat  coreutils  fzf  sed  (xclip or tmux or pbcopy)
### Video Demo      : 
### Source          : 
### References      : 


# set default cheat directory
cheatpath=~/Nextcloud/cheat
cd "$cheatpath"

# start fuzzy searching
fzfsearch="$(grep '^#' * | fzf)"

# store results as variables
cheatbasename="$(printf "$fzfsearch" | cut -d ':' -f1)"
cheatcodetitle="$(printf "$fzfsearch" | cut -d ':' -f2-)"

# copy paragraph of code we selected to Linux X clipboard
[ -x "$(command -v xclip)" ] && cheat "$cheatbasename" | sed -n "/$cheatcodetitle/,/^$/p" | sed '/^$/d' | sed '1d' | xclip -selection clipboard

# copy paragraph of code we selected to TMUX clipboard
pidof tmux >/dev/null && tmux set-buffer "$(cheat "$cheatbasename" | sed -n "/$cheatcodetitle/,/^$/p" | sed '/^$/d' | sed '1d')"

# copy paragraph of code we selected to OSX clipboard
[ -x "$(command -v pbcopy)" ] && cheat "$cheatbasename" | sed -n "/$cheatcodetitle/,/^$/p" | sed '/^$/d' | sed '1d' | pbcopy
