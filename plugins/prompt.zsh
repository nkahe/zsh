
# Select Vi input mode if it's set (in Zshrc).
if [[ "$key_bindings" == vi ]]; then
  # Zsh documentation recommends this over 'set -o vi'.
  bindkey -v
  # Set beam cursor.
  print -n '\e[5 q'
fi

if [[ -n "$ID" && "$ID" == "raspbian" ]]; then
  # Zinit's updating below didn't work on Raspberry's executables so it's
  # updated manually.
  # zinit ice from"github-rel" bpick"*arm-unknown-linux-musleabihf*" as"program" \

  atload'!eval $(starship init zsh)' lucid
  # Load Starhip theme if available.
  if (( $+commands[starship] )); then
    eval $(starship init zsh);
  else
    # Light custom backup -theme.
    themefile=$ZDOTDIR/themes/simple_theme.zsh
    [[ -f $themefile ]] && source $themefile
  fi
else
  # zinit ice from"github-rel" as"program" atload'starship_init'
  # ! Command line substitution must be in parenthesis.
  zinit ice from"github-rel" as"program" atload'eval "$(starship init zsh)"'
  zinit load starship/starship
fi
