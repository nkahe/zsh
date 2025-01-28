#
# Executes commands at login post-zshrc.
#
# Authors: Sorin Ionescu, Prezto
#
# Add my own completions. You can search more from: https://github.com/zsh-users/zsh-completions/tree/master/src
# export fpath=($ZDOTDIR/completions $fpath)

# Execute code that does not affect the current session in the background.
{
  # Compile the completion dump to increase startup speed.
  zcompdump="$HOME/.cache/zsh/zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.#zwc") ]]; then
    zcompile "$zcompdump"
    echo "[zlogin] running: zcompile $zcompdump"
  fi
} &!
