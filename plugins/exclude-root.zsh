# Plugins which are skipped for root user.

if [[ $UID == 0 ]]; then
  return
fi

zinit ice wait"1" lucid as"program" pick"todo.sh"
zinit load todotxt/todo.txt-cli
