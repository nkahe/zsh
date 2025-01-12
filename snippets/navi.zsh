
# Key bindings changed

_navi_call() {
   local result="$(navi "$@" </dev/tty)"
   printf "%s" "$result"
}

_navi_widget() {
   local -r input="${LBUFFER}"
   local -r last_command="$(echo "${input}" | navi fn widget::last_command)"
   local replacement="$last_command"

   if [ -z "$last_command" ]; then
      replacement="$(_navi_call --print)"
   elif [ "$LASTWIDGET" = "_navi_widget" ] && [ "$input" = "$previous_output" ]; then
      replacement="$(_navi_call --print --query "$last_command")"
   else
      replacement="$(_navi_call --print --best-match --query "$last_command")"
   fi

   if [ -n "$replacement" ]; then
      local -r find="${last_command}_NAVIEND"
      previous_output="${input}_NAVIEND"
      previous_output="${previous_output//$find/$replacement}"
   else
      previous_output="$input"
   fi

   zle kill-whole-line
   LBUFFER="${previous_output}"
   region_highlight=("P0 100 bold")
   zle redisplay
}

#
# Bindings
#
zle -N _navi_widget

# jeffreytse/zsh-vi-mode: 💻 A better and friendly vi(vim) mode plugin for ZSH.
# https://github.com/jeffreytse/zsh-vi-mode
for keymap in 'emacs' 'viins' 'vicmd'; do
  zvm_after_init_commands+=("bindkey -M $keymap '$key_info[F4]' _navi_widget")
done

(( $+commands[fzf] )) && zvm_after_init_commands+=("source <(fzf --zsh)")

