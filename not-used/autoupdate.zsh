# Replaced by anachron -script.

zmodload zsh/datetime

epoch_target=14

function _current_epoch() {
  echo $(( $EPOCHSECONDS / 60 / 60 / 24 ))
}

function _update_zsh_custom_update() {
  echo "LAST_EPOCH=$(_current_epoch)" >! "${ZSH_CACHE_DIR}/zsh-custom-update"
}

function _upgrade_custom() {
  # zinit self-update && zplugin update --all
  zsh -ic 'zinit self-update; zinit update --all -p 20 &' # Update zsh plugins.
}

if [ -f "${ZSH_CACHE_DIR}/zsh-custom-update" ]
then
  . "${ZSH_CACHE_DIR}/zsh-custom-update"

  if [[ -z "$LAST_EPOCH" ]]
  then
    LAST_EPOCH=0
  fi

  epoch_diff=$(($(_current_epoch) - $LAST_EPOCH))
  if [ $epoch_diff -gt $epoch_target ]
  then
      echo "Update plugins? [Y/n]: \c"
      read line
      if [[ "$line" == Y* ]] || [[ "$line" == y* ]] || [ -z "$line" ]
      then
        (_upgrade_custom)
      fi
    _update_zsh_custom_update
  fi
else
  _update_zsh_custom_update
fi

unset -f _update_zsh_custom_update _upgrade_custom _current_epoch
