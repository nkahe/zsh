#!/bin/zsh

# If not running interactively
[[ $- != *i* ]] && return

# Record the start time in nanoseconds when Zsh starts
zsh_start_time=$(date +%s%N)

# Define a precmd hook to run just before the prompt is displayed
function show-elapsed-time() {
  # Get the current time just before showing the prompt
  zsh_end_time=$(date +%s%N)

  # Calculate the time difference in milliseconds
  # Convert nanoseconds to milliseconds
  elapsed_time=$(( (zsh_end_time - zsh_start_time) / 1000000 ))

  # Display the total time taken for Zsh to initialize
  echo "Zsh startup time: ${elapsed_time} ms\n"

  add-zsh-hook -d precmd show-elapsed-time
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd show-elapsed-time

# Uncomment to profile speed.
#zmodload zsh/zprof

# Load common mime-types
# onkohan mitään hyötyä? hidastaa käynnistymistä selvästi.
# autoload -U zsh-mime-setup; zsh-mime-setup

# provide a simple prompt till the theme loads
PS1="%~ ❯ "

# Reset to default key bindings. Needs to be before any key binding changes.
bindkey -d

# Set the default keymap. Needs to be before sourcing fzf Zsh file.
bindkey -e

# Väliaikaisesti.
source "$HOME/.profile"

# Set the terminal multiplexer title format.
# zstyle ':prezto:module:terminal:multiplexer-title' format '%s'
# ----------------------------------
# Uncomment if you want to skip plugins for tty.
# if [[ ! "$TERM" == (dumb|linux) ]]; then

# Load Zinit - Zsh plugin manager. https://github.com/zdharma-continuum/zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
source "$ZINIT_HOME/bin/zinit.zsh"

ZINIT[ZCOMPDUMP_PATH]="${ZSH_CACHE_DIR:-$ZDOTDIR}/zcompdump"

# Load and initialize the completion system ignoring insecure directories with a
# cache time of 20 hours, so it should almost always regenerate the first time a
# shell is opened each day.
# Gives error if put aftere plugins

function set_hs_keys2() {
  # Define key bindings for up/down history search
  local -A keys=(
    [up]='\eOA' [up2]='^[[A' [down]='\eOB' [down2]='^[[B'
  )

  # Bind keys for emacs and viins keymaps
  for keymap in emacs viins; do
    bindkey -M "$keymap" "${keys[up]}" history-substring-search-up
    bindkey -M "$keymap" "${keys[up2]}" history-substring-search-up
    bindkey -M "$keymap" "${keys[down]}" history-substring-search-down
    bindkey -M "$keymap" "${keys[down2]}" history-substring-search-down
  done

  # Bind keys for vicmd keymap (vi command mode)
  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down
}

function set_hs_keys() {
  # Define key bindings for up and down actions
  local -A keys=([up]='\eOA' [up2]='^[[A' [down]='\eOB' [down2]='^[[B')

# Bind the up and down keys for each keymap in the array
  for keymap in emacs vicmd viins; do
    for action in up down; do
      bindkey -M "$keymap" "${keys[$action]}" "history-substring-search-${action}"
      bindkey -M "$keymap" "${keys[${action}2]}" "history-substring-search-${action}"
    done
  done

  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down
}


# Load plugins and snippets
function load_common_plugins() { #{{{

  # Don't rename executables if want completion to work.
  # Raspille:
  # https://github.com/starship/starship/releases/latest/download/starship-arm-unknown-linux-musleabihf.tar.gz

  # "lucid" = no non-error output. "light" = no plugin tracking or reporting.
  # "wait" = parallel "turbo-mode".
  # ! if "mv" executable completions probably don't work.

  # ! Needs to be before completion settings.
  # Colors for ls/eza/exa. Doesn't work is put in .zprofile.
  # Patched from LS_COLORS: A collection of LS_COLORS definitions.
  # https://github.com/trapd00r/LS_COLORS/tree/master
  ls_colors="$HOME/.config/shells/ls_colors.sh"
  if [[ -e $ls_colors ]]; then
    zinit ice id-as"LS_COLORS"
    zinit snippet "$ls_colors"
  fi
  # zinit ice atinit'dircolors -b ls_colors > ls_colors.zsh' pick"ls_colors.zsh"

  # General Colorizer.
  file="$HOME/.config/shells/grc.sh"
  if [[ -e $file ]]; then
    zinit ice wait"1" id-as"grc.sh" lucid
    zi snippet $file
  fi

  if [[ $HOST == raspberry* ]]; then
    # Zinit's updating below didn't work on Raspberry's executables so it's
    # updated manually.§§
    # zinit ice from"github-rel" bpick"*arm-unknown-linux-musleabihf*" as"program" \
      atload'!eval $(starship init zsh)' lucid
    if (( $+commands[starship] )); then
      eval $(starship init zsh);
    else
      # Backup -theme.
      themefile=$ZDOTDIR/themes/oma_teema.zsh-theme
      [[ -f $themefile ]] && source $themefile
    fi
  else
    # zinit ice from"github-rel" as"program" atload'starship_init'
    # ! Command line substitution must be in parenthesis.
    zinit ice from"github-rel" as"program" atload'eval "$(starship init zsh)"'
    zinit load starship/starship
  fi

  # Settings for Prezto -modules/snippets.
  #zinit light "$ZDOTDIR"/.zpreztorc
  zinit snippet "$ZDOTDIR"/.zpreztorc

  # Sets general shell options and defines termcap variables.
  zinit snippet PZT::modules/environment/init.zsh

  # Sets directory options and defines directory aliases.
  zinit snippet PZT::modules/directory/init.zsh

  # Sets history options and defines history aliases.
  zinit snippet PZT::modules/history/init.zsh

  # Forked version of Prezto terminal. Use wait since this takes some time.
  zinit ice wait lucid
  zinit snippet "$ZDOTDIR/plugins/titles.zsh"

  # Sets history options and defines history aliases.
  #zinit snippet PZT::modules/editor/init.zsh

  zinit ice wait"2" lucid
  zinit snippet OMZP::extract

  # bashmount: Tool to mount and unmount removable media from the command-line
  # https://github.com/jamielinux/bashmount
  zinit ice wait"2" lucid as"program" pick"bashmount"
  zinit load jamielinux/bashmount

  # Command Help. Extract help text from builtin commands and man pages.
  # https://github.com/learnbyexample/command_help
  zinit ice wait"1" lucid as"program" pick"ch"
  zinit load learnbyexample/command_help

  # Fzf: "If you use vi mode on bash, you need to add set -o vi before source
  # ~/.fzf.bash in your .bashrc, so that it correctly sets up key bindings
  # for vi mode."
  (( $+commands[fzf] )) && source <(fzf --zsh)

  # fzf-z: Plugin for zsh to integrate fzf and zsh's z plugin.
  # https://github.com/andrewferrier/fzf-z . Has to be after fzf.
  #zinit ice wait lucid atinit"export FZFZ_SUBDIR_LIMIT=0"
  #zinit load andrewferrier/fzf-z
  # Directories under the current directory. The number of these shown in
  # fzf is limited by the FZFZ_SUBDIR_LIMIT environment variable, which defaults
  # to 50. If you don't want those to be shown, simply set this to 0.

  # rvaiya/keyd: A key remapping daemon for linux.
  # https://github.com/rvaiya/keyd
  # make'!...' -> run make before atclone & atpull
  zinit ice wait"2" lucid as"program" make'!' pick"bin/keyd" \
    atclone"sudo systemctl enable --now keyd" \
    cp"keyd.1.gz -> $HOME/.local/man/man1"
  zinit load rvaiya/keyd

  zinit ice wait"1" lucid as"program" pick"radcard"
  zinit load superjamie/snippets

  # Tungsten - WolframAlpha CLI. https://github.com/ASzc/tungsten
  zinit ice wait"2" lucid as"program" pick"tungsten.sh" atload"alias ask=tungsten.sh"
  zinit load ASzc/tungsten

  # A CLI tool that scrapes Google search results and SERPs that provides
  # instant and concise answers. https://github.com/Bugswriter/tuxi
  zinit ice wait"2" as"program" pick"tuxi" lucid
  zinit load Bugswriter/tuxi

  # Binary is installed by distro package manager.
  #zinit ice wait lucid multisrc"shell/{completion,key-bindings}.zsh"
  #zinit load junegunn/fzf

  # agkozak/zsh-z: Jump quickly to directories that you have visited "frecently."
  # A native Zsh port of z.sh. https://github.com/agkozak/zsh-z
  #local file="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/z"
  #zinit ice wait lucid atinit"export _Z_DATA=$file" atclone"touch $file"
  #zinit load agkozak/zsh-z

  # zsh-completions: Additional completion definitions for Zsh.
  # https://github.com/zsh-users/zsh-completions
  zinit light zsh-users/zsh-completions

  # Fish-like autosuggestions for zsh.
  # https://github.com/zsh-users/zsh-autosuggestions
  zinit ice wait"2" lucid atload"_zsh_autosuggest_start" \
   atinit"export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8' \
      ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd \
      ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30"
  zinit load zsh-users/zsh-autosuggestions

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

  # ZSH plugin that reminds you to use existing aliases for commands you
  # just typed. https://github.com/MichaelAquilina/zsh-you-should-use
  # setaf 10 refers to color.
  zinit ice wait lucid
  zinit light "MichaelAquilina/zsh-you-should-use"
  export YSU_MESSAGE_FORMAT="$(tput setaf 10)There is an alias for that: %alias$(tput sgr0)"

  # Fish shell like syntax highlighting for Zsh.
  # https://github.com/zsh-users/zsh-syntax-highlighting.
  if [[ $HOST != raspberry* ]]; then
    # Gives error if variable isn't set.
    zinit ice wait lucid atinit"zpcompinit; zpcdreplay;export region_highlight=''"
    zinit load zsh-users/zsh-syntax-highlighting

    # Defer: set the priority when loading. e.g., zsh-syntax-highlighting must
    # be loaded after executing compinit command and sourcing other plugins
    # (If the defer tag is given 2 or above, run after compinit command)

    # zdharma-continuum/fast-syntax-highlighting: Feature-rich syntax highlighting for ZSH
    # https://github.com/zdharma-continuum/fast-syntax-highlighting

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

  fi

  eval "$(zoxide init zsh)"

  # ! Load after syntax-highlighting !
  # history-substring-search. Type in any part of any previously  entered
  # command and press the UP and DOWN arrow keys to cycle through the matching
  # commands. https://github.com/zsh-users/zsh-history-substring-search.

#   bindkey -M vicmd "?" history-incremental-pattern-search-backward
#   bindkey -M vicmd "/" history-incremental-pattern-search-forward

  zinit ice wait"1" lucid atload"_zsh_highlight" atinit"set_hs_keys"
  zinit load zsh-users/zsh-history-substring-search

} # }}}

function load_user_plugins() { # {{{
  # Used only for non-root user

  zinit ice wait"1" lucid as"program" pick"todo.sh" atload"alias todo=todo.sh"
  zinit load todotxt/todo.txt-cli

  zinit ice wait"2" lucid as"program" has"git" pick"yadm" \
    cp"yadm.1 -> $HOME/.local/man/man1" atpull'%atclone'
  zinit load TheLocehiliosan/yadm

} # }}}
#
function load_local_configs() { # {{{

#   zinit ice multisrc"*.{zsh,sh}" lucid
#   zinit light $ZDOTDIR
#
#   zinit ice multisrc"*.zsh" lucid
#   zinit light $ZDOTDIR/plugins

  # snippetillä käytti joskus cachea.
  source "$ZDOTDIR/bindings.zsh"

  # Alternative method if want to measure profile by file.
  for file in $ZDOTDIR/*.zsh
  do
    # Bindings have loaded earlier.
    [[ $file == *bindings.zsh ]] && continue
    # echo $file
    #source "$file"
    #zinit ice wait"0" lucid
    zinit snippet "$file"
  done

  zinit ice id-as"aliases.sh"
  zinit snippet $ZDOTDIR/aliases.sh

  # Note. Install local completions by running once in terminal:
  # zinit creinstall $ZDOTDIR/completions

  # Konsole/Yakuake and Kitty already have this.
  # zinit snippet OMZ::plugins/last-working-dir/last-working-dir.plugin.zsh

} # }}}
# End {{{

function end_message() {
  #  Most important part of config.
  if [[ $UID == 0 ]]; then
    echo "\nBy the Power of Grayskull, you are a root!"
    # If not launched inside NeoVim
    # elif which fortune &>/dev/null && [[ -z "$NVIM_LISTEN_ADDRESS" ]] ; then
    #   echo
    #   fortune
  fi
}

load_common_plugins
[[ $UID != 0 ]] && load_user_plugins
load_local_configs

#source $ZDOTDIR/bindings-test.zsh

#autoload -Uz _zinit
#(( ${+_comps} )) && _comps[zinit]=_zinit

# zinit cdreplay -q
# -q is for quiet; actually run all the `compdef's saved before 'compinit`
# call (`compinit' declares the `compdef' function, so it cannot be used until
# `compinit` is ran; zinit solves this via intercepting the `compdef'-calls
# and storing them for later use with `zinit cdreplay')

end_message
# Uncomment to show speed profiling stats.
#zprof

# }}}
