# This file is for common aliases compatible for Zsh, Bash and Fish -shells.

# Variables expand when defined which is fine for these use cases.
# shellcheck disable=SC2139

function has() {
  command -v "$@" &> /dev/null
}

# Extra applications {{{1

file="$HOME/src/nvim-linux-x86_64/bin/nvim"
has file && alias nvim="$file"

## AppImages

# Neovide - Simple, no-nonsense, cross-platform GUI for Neovim. https://neovide.dev
# file="$HOME/Applications/neovide.AppImage"
# has file && alias neovide="$file"

# file="$HOME/Applications/nvim-linux-x86_64.appimage"
# has file && alias nvim-nightly="$file"

# AppImageUpdate. https://github.com/AppImageCommunity/AppImageUpdate
file="$HOME/Applications/AppImageUpdate-x86_64.AppImage"
has file && alias AppImageUpdate="$file"

file="$HOME/Applications/appimageupdatetool-x86_64.AppImage"
has file && alias appimage-update="$file"

# firenvim: Embed Neovim in Chrome, Firefox & others. https://github.com/glacambre/firenvim
alias firenvim='NVIM_APPNAME=nvim-mini nvim --headless "+call firenvim#install(0) | q"'

function nvr() {
  local target="$1"
  if [ -z "$target" ]; then
    echo "Usage: nvr <file>"
    return 1
  fi

  # Find Neovim server
  local server="${NVIM:-$(ls -t /tmp/nvim.* 2>/dev/null | head -n 1)}"
  if [ ! -S "$server" ]; then
    echo "No running Neovim server found."
    return 1
  fi

  # Resolve path from current shell CWD
  local abs_path
  abs_path="$(realpath "$1" 2>/dev/null || echo "$1")"

  # Open file in existing Neovim
  nvim --server "$server" --remote "$abs_path"

  # nvim --server "$server" --remote-send "<C-\\><C-N>:buffer ${abs_path}<CR>"
  # nvim --server "$server" --remote-send "<C-\\><C-N>:edit ${abs_path}<CR>:q!<CR>"
  # nvim --server "$server" --remote-expr "execute('edit ' . fnameescape('$abs_path')) | if &buftype ==# 'terminal' | quit | endif"
  # nvim --server "$server" --remote-send "<C-\\><C-N>:edit ${abs_path}<CR>:q!<CR>"
  # nvim --server "$server" --remote-expr "execute('edit ' . fnameescape('$abs_path'))"
  # nvim --server "$server" --remote-expr \
  # "execute('edit ' . fnameescape('$abs_path')) |
  # if &buftype ==# 'terminal' |
  #   Snacks.terminal.toggle() |
  # endif"
}


# nvimpager: Use nvim as a pager to view manpages, diffs, etc with nvim's syntax
# highlighting. https://github.com/lucc/nvimpager
alias nvp='nvimpager'

alias restart-xdg='systemctl --user restart plasma-xdg-desktop-portal-kde'

# has conky && alias conky="conky --config $HOME/.config/conkyrc"
has kitty && alias icat="kitty +kitten icat"
  # Show images with Kitty's icat. https://sw.kovidgoyal.net/kitty/kittens/icat.html

# vimwiki: Personal Wiki for Vim. https://github.com/vimwiki/vimwiki
# ( <Leader>ww is keymap for VimWiki in Vim)

if has nvim; then
  WikiEditor="nvim"
elif has vim; then
  WikiEditor="vim"
fi

# Add 'wincmd w' if want to focus file.
ww() { $WikiEditor -c ":execute 'cd ~/Documents/notes|NERDTreeToggle|wincmd w|VimwikiIndex'"; }

# ffind: A sane replacement for find. https://github.com/jaimebuelta/ffind
# alias ffind='ffind --hidden'    # Show also hidden files.

muttrc="$HOME/.config/mutt/muttrc"
if [[ -f ~/.config/mutt/muttrc ]]; then
  if has neomutt; then
    alias mutt="neomutt -F $muttrc"
  elif has mutt; then
    alias mutt="mutt -F $muttrc"
  fi
fi
unset muttrc

# Tail with colors.
has ccze && tailc () { tail "$@" | ccze -A; }

# Translate-shell. https://github.com/soimort/translate-shell
if has trans; then
  function ten() {
    trans fi:en "$@" 2>/dev/null
  }
  function tfi() {
    trans en:fi "$@" 2>/dev/null
  }
fi

# Trayer. System Tray for WMs. Program has no config file.
# alias run-trayer='trayer --edge bottom --align right --widthtype request --heighttype pixel \
# --height 34 --SetDockType true --transparent true --alpha 90 --tint blue --monitor 1 --padding 10'

# https://github.com/lord63/tldr.py
# lord63/tldr.py: A python client for tldr: simplified and community-driven man pages.
alias tldrf='/usr/bin/tldr find'

# Termbin - terminal pastebin. https://termbin.com/
has nc && alias termbin="nc termbin.com 9999"

# kuvan jakaminen tähän palveluun jotenkin?
# https://imgbb.com/upload

# pipetys sekoaa tästä.
#alias tv="w3m -dump http://www.iltapulu.fi/\?timeframe\=2 | awk '/tv-ohjelmat/,/^$/'"

alias wttr=' curl http://wttr\.in/Oulu'

has yank-cli && alias yank=yank-cli

# Functions {{{1

# Print alphabets including scandic.
function alp() {
  for char in {A..Z} ; do
    printf "%s " "$char"
  done
  echo "Å Ä Ö"
}

function html-to-md () {
 find . -iname "*.html" -type f -exec sh -c \
  'pandoc -s -r html -t markdown_strict "${0}" -o "${0%.html}.md"' {} \;
}

if has paplay; then
  function minitimer() {
    (sleep "$1"; notify-send "Time is up" && paplay "$HOME/Sounds/complete.wav") &
  }
fi

function define() {
  if [[ $# -ge 2 ]]; then
    echo "define: too many arguments" >&2
    return 1
  fi
  curl -s "dict://dict.org/d:${1}" | $PAGER
}

# Copy file's path or CWD to clipboard.
function cppath {
  if [[ -n "$1" ]]; then
    # If a filename is provided, get the full path of the file
    fullpath=$(realpath "$1" 2>/dev/null)
    if [[ -f "$fullpath" || -d "$fullpath" ]]; then
      echo -n "$fullpath" | wl-copy
      echo "Copied: $fullpath"
    else
      echo "Error: '$1' is not a valid file or directory."
    fi
  else
    # If no parameter, copy the current working directory
    echo -n "$(pwd)" | wl-copy
    echo "Copied: $(pwd)"
  fi
}

function irc() {
  ssh -tt "$USER@rasp screen -rdU"
}

# Restart applications
function restart {
  [[ -z "$1" ]] && exit
  killall "$1"
  "$1" &>/dev/null &
}

# Core tools {{{1

# These are included in typical base install.

# Open file with associated program silently.
 # Huom. jos laittaa & perään, niin oletuksena bg jobeilla on pienempi prioriteetti.
 # You can turn this feature off by setting NO_BG_NICE.

#alias mount='sudo mount'
#alias umount='sudo umount'
alias updatedb='sudo updatedb'

# Extra default flags for interactive use

# OS X versions has some different flags.
if [[ $OSTYPE != 'darwin'* ]]; then
  alias chmod='chmod --preserve-root --verbose'
  alias chown='chown --preserve-root --verbose'
  alias cp="cp --verbose"
  alias df='df --human-readable'
  alias dd='dd status=progress'
  alias du='du --human'
  alias free='free --human'
  alias mv="mv --verbose"
  alias rm='rm --verbose'
  alias shred='shred --verbose --remove --zero'
  alias units="units --verbose --one-line --history \
  ${XDG_CACHE_DIR:-$HOME/.cache}/.units_history"
else
  alias chmod='chmod -v'
  alias chown='chown -v'
  alias cp='cp -v'
  alias df='df -h'
  alias du='du -h'
  alias free='free -h'
  alias mv='mv -v'
  alias rm='rm'
  alias shred='shred -v -z'
  alias units="units -v -1 -H ${XDG_CACHE_DIR:-$HOME/.cache}/.units_history"
fi

# Abbrevations

# allows you to create and view interactive sheets on the command-line.
# https://github.com/cheat/cheat. cs is short for cheatsheet
alias cs='cheat'
alias e="$EDITOR"
alias g='git'
alias jctl='journalctl'
alias o='xdg-open'
alias p="$PAGER"
# Put trash
alias pt='trash'
alias sctl='systemctl'
alias soft-reboot="sudo systemctl soft-reboot"
alias yd='yadm'
# z=zoxide
# x=extract (Prezto module)

# Handy aliases

alias cpp='rsync --archive -verbose --human-readable --info=progress2'
# Työhakemistossa olevien hakemistojen viemä tila.
alias du1='du --max-depth=1 | sort --numeric-sort'
# Ei alihakemistojen kokoa.
alias dud='du --separate-dirs | sort --numeric-sort --reverse'
alias logoff='loginctl terminate-session $XDG_SESSION_ID'
alias susp='systemctl suspend'

# List things more nicely

function lsblk {
  lsblk_default_args=('--output' 'NAME,SIZE,TYPE,FSTYPE,FSUSE%,MOUNTPOINTS,MODEL')
  grc lsblk "${@:-${lsblk_default_args[@]}}"
}

alias lspath='echo -e ${PATH//:/\\n}'

alias lsip='ip -brief -family inet addr'

# Don't show some long entires.
alias lsenv='env | grep -vE "LS_COLORS|LESS_TERMCAP" | sort -f | column -t -s "=" -E 2'

function lsmount {
  echo "DEVICE PATH TYPE FLAGS"
  mount | awk '$2="";1' | column -t
}

# List 256 foreground colors. There's separate script file for background colors.
function lscolors {
  for i in {0..255}
    do echo -e "\e[38;05;${i}m${i}"
  done | column -c 180 -s ' '
}

# Grep from processer and list info with headers.
# shellcheck disable=SC2009
function psg {
  echo 'USER         PID %CPU  %MEM   VSZ   RSS TTY      STAT START    TIME COMMAND'
  ps aux | grep --color=always -E "$@" | grep -v grep
}

# termdown: Countdown timer and stopwatch in your terminal
# https://github.com/trehn/termdown
if has termdown; then
  function td {
    termdown "$@" && notify-send "Time is up!" && paplay "$HOME/Sounds/complete.wav"
  }
fi

function tm {
  timer "$@" && notify-send "Time is up!" && paplay "$HOME/Sounds/complete.wav"
}

# function _ignore() {
#   # Aliases for ls
#   opts="--group-directories-first --color=always"
#   # Base ls command used after for aliases.
#   if has eza; then
#     _ls="eza --icons $opts"
#   elif has exa; then
#     _ls="exa --icons $opts"
#   else
#     _ls="ls $opts"
#   fi
#   unset opts
#
#   # Function for ls (overrides binary). Needs to be functions since it's used
#   # by chpwd().
#   function ls() {
#   $_ls "$@"
#   }
#
#   # note: --group-directories-first doesn't apply to symlinks.
#   # eza:lla myös --group
#   alias sl=ls \
#     ll="$_ls -l" \
#     lsa="$_ls -a" \
#     la="lsa" \
#     lla="$_ls -l -a" \
#     lsd="$_ls -d */" \
#     lld="$_ls -l -d */"
# }

# Disable alias expansion safely in both bash and zsh
if [ -n "$BASH_VERSION" ]; then
  shopt -u expand_aliases 2>/dev/null
elif [ -n "$ZSH_VERSION" ]; then
  setopt no_aliases 2>/dev/null
fi

LS_FLAGS=(--group-directories-first --color=always)

if has eza; then
  LS_CMD=(eza --icons "${LS_FLAGS[@]}")
elif has exa; then
  LS_CMD=(exa --icons "${LS_FLAGS[@]}")
else
  LS_CMD=(ls "${LS_FLAGS[@]}")
fi

# Used in chpwd() in Zsh to needs to be a function.
function ls() {
  "${LS_CMD[@]}" "$@"
}

ll() { ls -l "$@"; }
lsa() { ls -a "$@"; }
la() { lsa "$@"; }
lla() { ls -l -a "$@"; }
lsd() { ls -d */ "$@"; }
lld() { ls -l -d */ "$@"; }

# Package management {{{1

# find alternative apps if it is installed on your system
#find_alt() { for i;do which "$i" >/dev/null && { echo "$i"; return 0;};done;return 1; }

# Tämä lakkasi toimimasta jostain syystä.
#export MNGR=$(find_alt zypper aptitude apt-get)

#echo "Package Manager" $MNGR "detected."

function power() { upower -i "/org/freedesktop/UPower/devices/battery_BAT$1"; }

# Find out distribution.
if [[ -f /etc/os-release ]]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$ID
elif has lsb_release; then
    # linuxbase.org
    OS=$(lsb_release -si)
fi

if [[ $OS == *fedora* ]]; then
  file=$([[ -d /sys/firmware/efi ]] && echo 'grub2-efi.cfg' || echo 'grub2.cfg')
  alias update-grub="sudo grub2-mkconfig -o /etc/$file"
elif [[ $OSTYPE == 'darwin'* ]]; then
  alias inf="brew info" \
        ins="brew install" \
        rem="brew uninstall" \
        up="brew update && brew upgrade" \
        list="brew list" \
        se="brew search"
fi
unset file
#}}}
# DEs and WMs {{{1

if [[ -n "$XDG_SESSION_DESKTOP" && "$XDG_SESSION_DESKTOP" == "KDE" ]]; then
  qdbus="qdbus org.kde.ksmserver /KSMServer logout"
  # Don't use "shutdown"" on KDE but these:
  alias kpoweroff="$qdbus 0 2 0" \
        kreboot="$qdbus 0 1 0" \
        klogout="$qdbus 0 0 0" \
        restart-kwin='kwin_wayland --replace &>>/dev/null' \
        updatemenu=kbuildsycoca6
fi

# vi:ft=bash
