# These plugins take some resources.

# Skip these for weaker Raspberry. ID is set in /etc/os-release
if [[ -n "$ID" && "$ID" == "raspbian" ]]; then
  return
fi

# Lazyloading thefuck
if (( $+commands[thefuck] )); then
  function fuck() {
    if [[ thefuck_initialized!="true" ]]; then
      echo "init"
      eval "$(thefuck --alias)"
      thefuck_initialized="true"
    fi
    fuck "$@"
  }
fi

# Fish-like autosuggestions for zsh.
# https://github.com/zsh-users/zsh-autosuggestions

# zdharma-continuum/fast-syntax-highlighting: Feature-rich syntax highlighting for ZSH
#  https://github.com/zdharma-continuum/fast-syntax-highlighting

# NOTE: e.g., syntax highlighting must be loaded after executing compinit command
# and sourcing other plugins (If the defer tag is given 2 or above, run after
# compinit command)

zinit wait silent for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; \
    zicompinit; \
    zicdreplay; \
      export region_highlight=''; \
    (( $+commands[eza] )) && compdef eza=ls; \
    export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8' \
    ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd \
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30" \
    zdharma-continuum/fast-syntax-highlighting \
  blockf \
    zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

# Alternative syntax to define above plugins invividually.
#
# zinit ice wait"2" lucid atload"_zsh_autosuggest_start" \
#   atinit"export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8' \
#     ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd \
#     ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30"
# zinit load zsh-users/zsh-autosuggestions

# Gives error if variable isn't set.
# zinit ice wait lucid atinit"zpcompinit; \
#   zpcdreplay; \
#   export region_highlight=''; \
#   (( $+commands[eza] )) && compdef eza=ls"
# zinit light zdharma-continuum/fast-syntax-highlighting

# Alternative highlighting plugin
# Fish shell like syntax highlighting for Zsh.
# https://github.com/zsh-users/zsh-syntax-highlighting.
# zinit load zsh-users/zsh-syntax-highlighting

# Yet Another Dotfiles Manager - yadm https://yadm.io
zinit ice wait"2" lucid as"program" has"git" pick"yadm" \
  cp"yadm.1 -> $HOME/.local/man/man1" atpull'%atclone'
zinit load TheLocehiliosan/yadm

# ZSH plugin that reminds you to use existing aliases for commands you
# just typed. https://github.com/MichaelAquilina/zsh-you-should-use

# NOTE: setaf 10 refers to color.
zinit ice wait"2" lucid
zinit light "MichaelAquilina/zsh-you-should-use"
export YSU_MESSAGE_FORMAT="$(tput setaf 10)There is an alias for that: %alias$(tput sgr0)"

# Forked version of Prezto terminal. Use wait since this takes some time.
# zinit ice wait lucid
# zinit snippet "$snippets_dir/titles.zsh"
# source "$snippets_dir/titles.zsh"
