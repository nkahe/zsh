# These plugins take some resources and are lazy-loaded.

# thefuck
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

# zdharma-continuum/fast-syntax-highlighting: Feature-rich syntax highlighting for ZSH
#  https://github.com/zdharma-continuum/fast-syntax-highlighting

# zinit wait silent for \
#   atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay;\
#   (( $+commands[eza] )) && compdef eza=ls;\
#   export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8' \
#   ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd \
#   ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30" \
#     zdharma-continuum/fast-syntax-highlighting \
#   blockf \
#     zsh-users/zsh-completions \
#   atload"!_zsh_autosuggest_start" \
#     zsh-users/zsh-autosuggestions


# Fish-like autosuggestions for zsh.
# https://github.com/zsh-users/zsh-autosuggestions
zinit ice wait"2" lucid atload"_zsh_autosuggest_start" \
  atinit"export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8' \
    ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd \
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30"
zinit load zsh-users/zsh-autosuggestions

# Defer: set the priority when loading. e.g., zsh-syntax-highlighting must
# be loaded after executing compinit command and sourcing other plugins
# (If the defer tag is given 2 or above, run after compinit command)

# Fish shell like syntax highlighting for Zsh.
# https://github.com/zsh-users/zsh-syntax-highlighting.
# Gives error if variable isn't set.
zinit ice wait lucid atinit"zpcompinit; zpcdreplay;export region_highlight='';\
  (( $+commands[eza] )) && compdef eza=ls"
# zinit load zsh-users/zsh-syntax-highlighting
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice wait"2" lucid as"program" has"git" pick"yadm" \
  cp"yadm.1 -> $HOME/.local/man/man1" atpull'%atclone'
zinit load TheLocehiliosan/yadm

# ZSH plugin that reminds you to use existing aliases for commands you
# just typed. https://github.com/MichaelAquilina/zsh-you-should-use
# setaf 10 refers to color.
zinit ice wait lucid
zinit light "MichaelAquilina/zsh-you-should-use"
export YSU_MESSAGE_FORMAT="$(tput setaf 10)There is an alias for that: %alias$(tput sgr0)"

# Forked version of Prezto terminal. Use wait since this takes some time.
# zinit ice wait lucid
# zinit snippet "$snippets_dir/titles.zsh"
# source "$snippets_dir/titles.zsh"

# OMZ terminal titles.
# source $snippets_dir/termsupport.zsh
# zinit snippet OMZ::/lib/functions.zsh
# zinit snippet OMZ::/lib/termsupport.zsh
