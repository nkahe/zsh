
# Not handled by Zinit anymore for me.

# rvaiya/keyd: A key remapping daemon for linux.
# https://github.com/rvaiya/keyd
make'!...' -> run make before atclone & atpull
zinit ice wait"2" lucid as"program" make'!' pick"bin/keyd" \
  atclone"sudo systemctl enable --now keyd" \
  cp"keyd.1.gz -> $HOME/.local/man/man1"
    zinit load rvaiya/keyd

