#!/bin/zsh

# If not running interactively
[[ $- != *i* ]] && return

# Uncomment to profile speed.
# zmodload zsh/zprof

# Load common mime-types
# onkohan mitään hyötyä? hidastaa käynnistymistä selvästi.
# autoload -U zsh-mime-setup; zsh-mime-setup

# smart urls
# FIXME: edgellä ei toiminu.
# autoload -U bracketed-paste-url-magic
# zle -N self-insert bracketed-paste-url-magic

# Fzf: "If you use vi mode on bash, you need to add set -o vi before source
# ~/.fzf.bash in your .bashrc, so that it correctly sets up key bindings
# for vi mode."
set -o vi
#set -o emacs

PS1="%~ ❯ " # provide a simple prompt till the theme loads

# ---- Prezto terminal settings ----
# Terminal titles
zstyle ':prezto:module:terminal' auto-title 'yes'

# Set the window title format. Comment if don't want to change window title.
# zstyle ':prezto:module:terminal:window-title' format '%n@%m: %s'

# Set the tab title format.
zstyle ':prezto:module:terminal:tab-title' format '%s'

# Set the terminal multiplexer title format.
# zstyle ':prezto:module:terminal:multiplexer-title' format '%s'
# ----------------------------------
# Uncomment if you want to skip plugins for tty.
# if [[ ! "$TERM" == (dumb|linux) ]]; then

source "$ZDOTDIR"/utils/utils.zsh

# {{{ Load Zinit plugin manager

# Zinit - Flexible Zsh plugin manager . https://github.com/zdharma-continuum/zinit

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"

# Install Zinit if not found.
function check_zinit() {
  if [[ ! -d $ZINIT_HOME/bin ]]; then
    if ! has git; then
      echo "Error: Install Git to install Zinit."
    fi
    while true; do
      if [[ $UID == 0 ]]; then
        read -q "answer?Make symlink: $ZINIT_HOME -> /home/henri/.local/share/zinit (yes/no)? "
      else
        read -q "answer?Install Zinit in $ZINIT_HOME (yes/no)? "
      fi
      echo -e "\n"
      case $answer in
        [Nn] )
          break
          ;;
        [Yy] )
          if [[ $UID == 0 ]]; then
            ln -sdv /home/henri/.local/share/zinit $ZINIT_HOME
          else
            print 'Ok, installing Zinit...'
            mkdir -pv "$ZINIT_HOME"
            # This path could be /zinit.git as in their example instead of /bin
            git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME/bin"
            compile_or_recompile "$ZINIT_HOME/bin/zinit.zsh"
            break
          fi
          ;;
        * ) echo "Please answer [y]es or [n]o." ;;
      esac
    done
  fi
}

check_zinit
source "$ZINIT_HOME/bin/zinit.zsh"

# No security checks
ZINIT[COMPINIT_OPTS]="-C"
# Must be after sourcing Zinit.
ZINIT[ZCOMPDUMP_PATH]="${ZSH_CACHE_DIR:-$ZDOTDIR}/zcompdump"
# }}}

# Add my own completions.
# https://github.com/zsh-users/zsh-completions/tree/master/src
# export fpath=($ZDOTDIR/completions $fpath)
# Note: jos ei toimi: force rebuild zcompdump by: rm .zcompdump; compinit

# Load and initialize the completion system ignoring insecure directories with a
# cache time of 20 hours, so it should almost always regenerate the first time a
# shell is opened each day.
# Gives error if put aftere plugins

# Load 3rd party plugins and set default settings. {{{
function load_plugins() {

  # Raspille:
  # https://github.com/starship/starship/releases/latest/download/starship-arm-unknown-linux-musleabihf.tar.gz

  # "lucid" means no output.
  #
  file="$HOME/.config/shells/profile/ls_colors.sh"
  [[ -e $file ]] && source "$file"

  if [[ $HOST == raspberry* ]]; then
    # Zinit's updating below didn't work on Raspberry's executables so it's
    # updated manually.
    # zinit ice from"github-rel" bpick"*arm-unknown-linux-musleabihf*" as"program" atload'!eval $(starship init zsh)' lucid
    has starship && eval $(starship init zsh)
  else
    zinit ice from"github-rel" as"program" atload'!eval $(starship init zsh)' lucid
  fi
  zinit load starship/starship

  # bashmount: Tool to mount and unmount removable media from the command-line
  # https://github.com/jamielinux/bashmount
  zinit ice wait lucid as"program" pick"bashmount"
  zinit load jamielinux/bashmount

  # zinit ice wait lucid as"program" pick"clicksnap"
  # zinit light napcok/clicksnap

  # Extract help text from builtin commands and man pages.
  # https://github.com/learnbyexample/command_help
  # Bash-script. Works by adding symlink from
  zinit ice wait as"program" pick"ch" lucid
  zinit load learnbyexample/command_help

  # Available in repositories
  # zinit ice from"gh-r" as"program"
  # zinit light junegunn/fzf-bin

  # fzf-z: Plugin for zsh to integrate fzf and zsh's z plugin.
  # https://github.com/andrewferrier/fzf-z
  # Has to be after fzf.
  zinit ice wait lucid atinit"export FZFZ_SUBDIR_LIMIT=0"
  zinit load andrewferrier/fzf-z
  # Directories under the current directory. The number of these shown in
  # fzf is limited by the FZFZ_SUBDIR_LIMIT environment variable, which defaults
  # to 50. If you don't want those to be shown, simply set this to 0.

  # rvaiya/keyd: A key remapping daemon for linux.
  # https://github.com/rvaiya/keyd
  # make'!...' -> run make before atclone & atpull
  zinit ice wait lucid as"program" make'!' pick"bin/keyd" \
    atclone"sudo systemctl enable --now keyd" \
    cp"keyd.1.gz -> $HOME/.local/man/man1"
  zinit load rvaiya/keyd

  zinit ice wait lucid as"program" pick"radcard"
  zinit load superjamie/snippets

  # zinit light denysdovhan/spaceship-prompt

  zinit ice wait lucid as"program" pick"tdrop"
  # zinit ice wait lucid as"program" pick"tdyyrop"
  zinit load noctuid/tdrop

  # Use alias instead of move so completions work correctly.
  zinit ice wait lucid as"program" pick"todo.sh" atinit"alias todo=todo.sh"
  zinit load todotxt/todo.txt-cli

  # zinit ice as"completion" pick"src/_cheat"
  # zinit light zsh-users/zsh-completions

  # Tungsten - WolframAlpha CLI. https://github.com/ASzc/tungsten
  zinit ice wait lucid as"program" pick"tungsten.sh" mv"tungsten.sh -> ask"
  zinit load ASzc/tungsten

  # A CLI tool that scrapes Google search results and SERPs that provides
  # instant and concise answers. https://github.com/Bugswriter/tuxi
  zinit ice wait as"program" pick"tuxi" lucid
  zinit load Bugswriter/tuxi

  # zinit ice as"completion" pick"_todo.sh"
  # zinit light $ZDOTDIR/completions

  # A simple wrapper of zypper and osc that allows for searching and installing
  # of packages from openSUSE Build Service repos
  # https://github.com/simoniz0r/zyp
  # zinit ice wait lucid as"program" cp"zyp.sh -> zyp" pick"zyp"
  # zinit light simoniz0r/zyp

  # zinit ice from"github-rel" as"program" pick"cheat-linux-amd64.*"
    # extract mv"cheat-linux-amd64 -> cheat" lucid
  # zinit light cheat/cheat

  # Already in Suse's /etc/zshrc. Uses the command-not-found package's zsh
  # support if there's one available.
  # [[ -e /etc/zsh_command_not_found ]] && source /etc/zsh_command_not_found

  # Binary is installed by distro package manager.
  zinit ice wait lucid multisrc"shell/{completion,key-bindings}.zsh"
  zinit load junegunn/fzf

  zinit ice wait lucid as"program" has"git" pick"yadm" \
    cp"yadm.1 -> $HOME/.local/man/man1" atpull'%atclone'
  zinit load TheLocehiliosan/yadm

  # agkozak/zsh-z: Jump quickly to directories that you have visited "frecently."
  # A native Zsh port of z.sh.
  # https://github.com/agkozak/zsh-z
  local file="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/z"
  zinit ice wait lucid atinit"export _Z_DATA=$file" atclone"touch $file"
  zinit load agkozak/zsh-z

  # z - jump around. https://github.com/rupa/z
  # zinit ice wait lucid
  # zinit light rupa/z

  # Fish-like autosuggestions for zsh.
  # https://github.com/zsh-users/zsh-autosuggestions
  zinit ice wait"0" lucid atload"_zsh_autosuggest_start" \
   atinit"export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8' \
      ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd \
      ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30"
  zinit load zsh-users/zsh-autosuggestions

  # ZSH plugin that reminds you to use existing aliases for commands you
  # just typed. https://github.com/MichaelAquilina/zsh-you-should-use
  # zinit ice wait lucid
  # zinit light "MichaelAquilina/zsh-you-should-use"

  # xiny: Simple command line tool for unit conversions
  # https://github.com/bcicen/xiny
  zinit ice wait lucid from"github-rel" as"program" bpick"*linux*" mv"xiny* -> xiny"
  zinit load bcicen/xiny

  # Gemini client
  # zinit ice wait from"github-rel" as"program" bpick"*linux_64-bit" mv"amfora* -> amfora"
  # zinit light makeworld-the-better-one/amfora

  # zinit ice atinit'dircolors -b ls_colors > ls_colors.zsh' pick"ls_colors.zsh"
  # zinit light ~/zsh

  # # Most enrivonment variables are at $DOTDIR/init.sh
  # # http://zsh.sourceforge.net/Doc/Release/Completion-System.html

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

  # Fish shell like syntax highlighting for Zsh.
  # https://github.com/zsh-users/zsh-syntax-highlighting.
  if [[ $HOST != raspberry* ]]; then
    # Gives error if variable isn't set.
    zinit ice atinit"zpcompinit; zpcdreplay; export region_highlight=''" lucid
    zinit load zsh-users/zsh-syntax-highlighting
    # Defer: set the priority when loading. e.g., zsh-syntax-highlighting must
    # be loaded after executing compinit command and sourcing other plugins
    # (If the defer tag is given 2 or above, run after compinit command)
  fi

  # *Load after syntax-highlighting*
  # history-substring-search. Type in any part of any previously  entered
  # command and press the UP and DOWN arrow keys to cycle through the matching
  # commands. https://github.com/zsh-users/zsh-history-substring-search.
  zinit ice wait atload"_zsh_highlight" lucid \
    atinit"bindkey -a 'k' history-substring-search-up; \
    bindkey -a 'j' history-substring-search-down"
  zinit load zsh-users/zsh-history-substring-search

} # }}}
# Load own configs {{{
load_personal_configs() {

  # zinit ice wait multisrc"*.zsh" lucid
  # zinit load $ZDOTDIR
  zinit ice multisrc"*.zsh" lucid
  zinit light $ZDOTDIR

  for file in $ZDOTDIR/completions/*
  do
    zinit ice as"completion"
    zinit snippet "$file"
  done

  for file in $ZDOTDIR/*.zsh $ZDOTDIR/plugins/*.zsh
  do
    # zinit ice
    zinit snippet "$file"
  done

  zinit snippet "$HOME/.config/shells/aliases.sh"

  # zinit ice pick"Completion/Unix/Command/_todo.sh" as"completion"
  # zinit light zsh-users/zsh

  # zinit ice lucid
  # zinit snippet $ZDOTDIR/plugins/*.zsh

  # Doesn't work. Kitty supports this.
  # zinit snippet OMZ::plugins/last-working-dir/last-working-dir.plugin.zsh

  # themefile=$ZDOTDIR/themes/oma_teema.zsh-theme
  #  if [[ -f $themefile ]]; then
  #    source $themefile
  #  fi
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

function main() {
  load_plugins
  load_personal_configs

  # autoload -Uz _zinit
  # (( ${+_comps} )) && _comps[zinit]=_zinit

  # zinit cdreplay -q
  # -q is for quiet; actually run all the `compdef's saved before 'compinit`
  # call (`compinit' declares the `compdef' function, so it cannot be used until
  # `compinit` is ran; zinit solves this via intercepting the `compdef'-calls
  # and storing them for later use with `zinit cdreplay')

  end_message
  # Uncomment to show speed profiling stats.
  # zprof
}

main
# }}}
