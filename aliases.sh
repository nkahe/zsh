# This file is for common aliases compatible for Zsh, Bash and Fish -shells.

# Variables expand when defined which is fine for these use cases.
# shellcheck disable=SC2139

function has() {
  command -v "$@" &> /dev/null
}

function upvibre() {
  cd "$HOME/projects/vibreoffice/Nazo1412" || true
  unopkg remove vibreoffice
  VIBREOFFICE_VERSION="0.5.0" \make extension
  unopkg add "$HOME/projects/vibreoffice/Nazo1412/dist/vibreoffice-0.5.0.oxt"
}

alias firenvim='NVIM_APPNAME=nvim-mini nvim --headless "+call firenvim#install(0) | q"'
alias game="kscreen-doctor output.DP-1.mode.12"
alias normal="kscreen-doctor output.DP-1.mode.2"
alias nvp='nvimpager'

# Extra applications {{{1

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
alias termbin="nc termbin.com 9999"

# kuvan jakaminen tähän palveluun jotenkin?
# https://imgbb.com/upload

# pipetys sekoaa tästä.
#alias tv="w3m -dump http://www.iltapulu.fi/\?timeframe\=2 | awk '/tv-ohjelmat/,/^$/'"

alias wttr=' curl http://wttr\.in/Oulu'

has yank-cli && alias yank=yank-cli

# Functions {{{1

# Print alphabets
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

function minitimer() {
  (sleep "$1"; notify-send "Time is up" && paplay "$HOME/Sounds/complete.wav") &
}

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

# ud() {
#   curl -s "https://api.urbandictionary.com/v0/tooltip?term=${1}" |
#   python3 -c "import sys, json, html; print(html.unescape(json.load(sys.stdin)['string']).split('\n',2)[1])"
# }

# Core tools {{{1

# These are included in typical base install.

# Open file with associated program silently.
 # Huom. jos laittaa & perään, niin oletuksena bg jobeilla on pienempi prioriteetti.
 # You can turn this feature off by setting NO_BG_NICE.

# For non-root users.
if [[ $UID != 0 ]]; then
  #alias mount='sudo mount'
  #alias umount='sudo umount'
  alias updatedb='sudo updatedb'
fi

# Better default flags for interactive use

# OS X versions has some different flags.
if [[ $OSTYPE != 'darwin'* ]]; then
  cflags='--preserve-root -v'
  alias df='df --human-readable'
  alias du='du --human'
  alias free='free --human'
  alias ka='killall --verbose'
  alias rm='rm --verbose'
  alias shred='shred --verbose --remove --zero'
  alias units="units --verbose --one-line --history \
  ${XDG_CACHE_DIR:-$HOME/.cache}/.units_history"
else
  cflags='-v'
  alias df='df -h'
  alias du='du -h'
  alias free='free -h'
  alias ka='killall -v'
  alias rm='rm'
  alias shred='shred -v -z'
  alias units="units -v -1 -H ${XDG_CACHE_DIR:-$HOME/.cache}/.units_history"
fi
alias chmod="chmod $cflags"
alias chown="chown $cflags"
alias dd='dd status=progress'
unset cflags

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
function td {
  termdown "$@" && notify-send "Time is up!" && paplay "$HOME/Sounds/complete.wav"
}

# Aliases for ls

opts="--group-directories-first --color=always"

# Base ls command used after for aliases.
if has eza; then
  ls="eza --icons $opts"
elif has exa; then
  ls="exa --icons $opts"
else
  ls="ls $opts"
fi

# note: --group-directories-first doesn't apply to symlinks.
# eza:lla myös --group
alias ls="$ls" \
  sl=ls \
  ll="$ls -l" \
  lsa="$ls -a" \
  la="lsa" \
  lla="$ls -l -a" \
  lsd="$ls -d */" \
  lld="$ls -l -d */"
unset ls

# Package management {{{1

# find alternative apps if it is installed on your system
#find_alt() { for i;do which "$i" >/dev/null && { echo "$i"; return 0;};done;return 1; }

# Tämä lakkasi toimimasta jostain syystä.
#export MNGR=$(find_alt zypper aptitude apt-get)

#echo "Package Manager" $MNGR "detected."

if has rpm; then
  function rpm-isot {
    rpm -qa --queryformat="%{SIZE} %{NAME} %{VERSION}\n" \
      | sort -k 1 -n \
      | tail -n 100 \
      | awk '{size=$1; $1=""; print size, $0}' \
      | numfmt --field=1 --to=iec --suffix=B
  }
fi

function power() { upower -i "/org/freedesktop/UPower/devices/battery_BAT$1"; }

function update-grub-alias() {
  file=$([[ -d /sys/firmware/efi ]] && echo 'grub2-efi.cfg' || echo 'grub2.cfg')
  alias update-grub="sudo grub2-mkconfig -o /etc/$file"
}

if has zypper; then
  file="$HOME/.config/shells/zypper.sh"
  # shellcheck disable=SC1090
  [[ -s "$file" ]] && source "${file}"
fi

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
  update-grub-alias
  file="$HOME/.config/shells/dnf.sh"
  # shellcheck disable=SC1090
  [[ -f "$file" ]] && source "$file"
elif [[ $OSTYPE == 'darwin'* ]]; then
  alias inf="brew info" \
        ins="brew install" \
        rem="brew uninstall" \
        up="brew update && brew upgrade" \
        list="brew list" \
        se="brew search"
fi
#}}}
# DEs and WMs {{{1

if [[ -n "$XDG_SESSION_DESKTOP" ]]; then
  if [[ "$XDG_SESSION_DESKTOP" == "plasma5" || "$XDG_SESSION_DESKTOP" == "KDE" ]]
  then
    qdbus="qdbus org.kde.ksmserver /KSMServer logout"
    # Don't use shutdown on KDE but these:
    alias kpoweroff="$qdbus 0 2 0" \
          kreboot="$qdbus 0 1 0" \
          klogout="$qdbus 0 0 0" \
          restart-kwin='kwin_x11 --replace &>>/dev/null'
  fi
fi

# vi:ft=sh
