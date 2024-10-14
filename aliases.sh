# This file is for common aliases compatible for Zsh, Bash and Fish -shells.

MyNick='Hendrix'

alias game="kscreen-doctor output.DP-1.mode.12"
alias normal="kscreen-doctor output.DP-1.mode.2"

# Extra applications {{{1

alias restart-xdg='systemctl --user restart plasma-xdg-desktop-portal-kde'

# allows you to create and view interactive sheets on the command-line.
# https://github.com/cheat/cheat. cs is short for cheatsheet
has cheat && alias cs='cheat'
# has conky && alias conky="conky --config $HOME/.config/conkyrc"
has kitty && alias icat="kitty +kitten icat"
  # Show images with Kitty's icat. https://sw.kovidgoyal.net/kitty/kittens/icat.html

if has micro; then
  editor="micro"
elif has nvim; then
  editor="nvim"
elif has vim; then
  editor="vim"
else
  editor="nano"
fi
alias e=$editor

alias ls="eza --group-directories-first --color=always --icons"

alias g='git'

has khelpcenter && alias khelp='khelpcenter'

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

if has neomutt && [[ -f ~/.config/mutt/muttrc ]]; then
  alias mutt="neomutt -F ~/.config/mutt/muttrc"
elif has mutt && [[ -f ~/.config/mutt/muttrc ]]; then
  alias mutt="mutt -F ~/.config/mutt/muttrc"
fi

# susepaste - paste text on openSUSE Paste.
if has susepaste; then
   alias susepaste="susepaste -n $MyNick" \
         susepaste-screenshot="susepaste-screenshot -n $MyNick" \
         susepaste-scr='susepaste-screenshot'
fi

# Tail with colors.
has ccze && tailc () { tail "$@" | ccze -A; }

if has trans; then
  # Translate-shell. https://github.com/soimort/translate-shell
  alias ten=' trans fi:en "$@" 2>/dev/null' \
        tfi=' trans en:fi "$@" 2>/dev/null'
fi

# Trayer. System Tray for WMs. Program has no config file.
# alias run-trayer='trayer --edge bottom --align right --widthtype request --heighttype pixel --height 34 --SetDockType true --transparent true --alpha 90 --tint blue --monitor 1 --padding 10'

# https://github.com/lord63/tldr.py
# lord63/tldr.py: A python client for tldr: simplified and community-driven man pages.
has gio && alias tldrf='/usr/bin/tldr find'

if has gio; then
  # Put files to trash
  alias pt="gio trash" trash-empty='gio trash --empty'
fi

# Asettaa authorin. Tarttee paketin 'pastebinit'
has pastebinit && alias pastebinit=" pastebinit -a $MyNick"

alias termbin="nc termbin.com 9999"

# kuvan jakaminen tähän palveluun jotenkin?
# https://imgbb.com/upload

# pipetys sekoaa tästä.
#alias tv="w3m -dump http://www.iltapulu.fi/\?timeframe\=2 | awk '/tv-ohjelmat/,/^$/'"

alias wttr=' curl http://wttr\.in/Oulu'

has yank-cli && alias yank=yank-cli

# Functions {{{1

# A collection of useful bash functions to determine why stuff is installed

function rpm_aliases() {
  whyfile() {
      package=$(rpm -qf $1 --qf "%{NAME}")
      ret=$?
      echo -e "\nPackage: $package\n"
      (( $ret == 0)) || return
      zypper if $package
      whypkg $package
  }

  whycmd() {
      file=$(which $1)
      (($? == 0)) || return
      whyfile $file
  }

  pkgchg() {
      rpm -q --changelog $1 | less
  }
}

has rpm && rpm_aliases

# Print alphabets
alp() {
  for x in {A..Z} ; do
    printf $x" "
  done
  echo "Å Ä Ö"
}

# dutchcoders/transfer.sh: Easy and fast file sharing from the command-line.
# https://github.com/dutchcoders/transfer.sh
function transfer() {
  if [ $# -lt 1 ]; then
    echo -e "Easy file sharing from the command line https://transfer.sh"
    echo -e "Usage:   $0 <filename>"
    echo -e "Example: $0 file.zip file2.txt file3.jpg"
    return 1
  fi
  myArray=( "$@" )
  for arg in "${myArray[@]}"; do
    tmpfile=$( mktemp -t transferXXX )
    if tty -s; then
      basefile=$(basename "$arg" | sed -e 's/[^a-zA-Z0-9._-]/-/g')
      curl --progress-bar --upload-file "$arg" "https://transfer.sh/$basefile" >> $tmpfile
      else curl --progress-bar --upload-file "-" "https://transfer.sh/$arg" >> $tmpfile
    fi
    cat $tmpfile
    rm -f $tmpfile
  done
}

# man() {
#   LESS_TERMCAP_md=$'\e[1;36m'
#   LESS_TERMCAP_me=$'\e[0m'
#   LESS_TERMCAP_se=$'\e[0m'
#   LESS_TERMCAP_so=$'\e[01;44;160m'
#   LESS_TERMCAP_ue=$'\e[0m'
#   LESS_TERMCAP_us=$'\e[01;32m'
#   command man "$@"
# }

html-to-md () {
 find . -iname "*.html" -type f -exec sh -c 'pandoc -s -r html -t markdown_strict "${0}" -o "${0%.html}.md"' {} \;
}


# Wayland Tools ---------------------------------------------------------------

# Copy working directory to clipboard. Needs wl-clipboard.
if has wl-copy; then
  cpwd() { pwd | tr -d "\r\n" | wl-copy; }
fi


# X Tools ---------------------------------------------------------------------

function xclip_aliases() {
  # Handling clipboard with xclip. https://github.com/astrand/xclip
  ## copy to clipboard, ctrl+c, ctrl+shift+c
  alias xcopy='xclip -selection clipboard'

  # paste from clipboard, ctrl+v, ctrl+shitt+v
  alias xpaste='xclip -selection clipboard -o'

  # paste from highlight, middle click, shift+insert
  alias xselect='xclip -selection primary -o'

  # Kopioi leikepöydältä pastebiniin ja linkki leikepöydälle.
  alias cppb='xpaste | pastebinit | xcopy'

  # Copy working directory to clipboard. Needs xclip (bin).
  cpwd() { pwd | tr -d "\r\n" | xclip -selection clipboard; }

  # Copy file's (relational) path to clipboard
  cppath() { readlink --canonicalize "$1" | xclip -selection clipboard; }

  # Same with absolute file path.
  cprealpath() { realpath "$1" | xclip -selection clipboard; }
}

# For Xorg
has obxprop && alias obxp='echo Click a window; obxprop | grep "^_OB_APP"'
  # Show window name and class.
if has xprop; then
  alias xp='echo Click a window; xprop | grep "WM_WINDOW_ROLE\|WM_CLASS" && \
  echo "WM_CLASS(STRING) = \"NAME\", \"CLASS\""'
fi

if has xclip && [[ ! -n "$WAYLAND_DISPLAY" ]]; then

  has xbindkeys && alias xbindkeys="xbindkeys -f $HOME/.config/xbindkeysrc"

  xclip_aliases

  # Tuli virheilmoituksia jos näistä teki funktioita! (Maximum nested funktion reached)
  function moff () { xset dpms force off ;}      # Näyttö pois päältä
  function lid-off () { xrandr --output LVDS1 --off ;}
  function lid-on () { xrandr --output LVDS1 --on ;}
fi

# -----------------------------------------------------------------------------

irc() { ssh -tt $USER@rasp screen -rdU ;}

# Restart applications
function restart() {
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

# Turn Caps Lock to Ctrl
# alias caps-ctrl='setxkbmap -option "ctrl:nocaps"'
# alias caps-esc='setxkbmap -option "caps:escape"'
# alias caps-esc='setxkbmap -option "caps:swapescape"'

# Open file with associated program silently.
 # Huom. jos laittaa & perään, niin oletuksena bg jobeilla on pienempi prioriteetti.
 # You can turn this feature off by setting NO_BG_NICE.

# For non-root users.
if [[ $UID != 0 ]]; then
  alias mount='sudo mount' umount='sudo umount'
  alias updatedb='sudo updatedb'
fi

# Add default flags

alias chmod="chmod $cflags" chown="chown $cflags"
alias dd='dd status=progress'
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
alias chmod="chmod $cflags" chown="chown $cflags"

# Shorter commands

alias p="$PAGER"
alias jctl='journalctl' sctl='systemctl'
alias his=' history'
alias xo='xdg-open'

# Handy aliases

alias btdf='btrfs filesystem df'
# Työhakemistossa olevien hakemistojen viemä tila.
alias du1='du --max-depth=1 | sort --numeric-sort'
# Ei alihakemistojen kokoa.
alias dud='du --separate-dirs | sort --numeric-sort --reverse'
alias logoff='loginctl terminate-session $XDG_SESSION_ID'
alias restart-pcman='pcmanfm-qt --desktop-off && pcmanfm-qt --desktop'
alias susp='systemctl suspend'

# List things

alias lspath='echo -e ${PATH//:/\\n}'
# Hakemistojen viemä tila. Ei alihakemistojen kokoa.
# Ei toimi edellisen aliaksen kanssa.  pitäis korjata.
alias lsip='ip -brief -family inet addr show'
alias lsenv='env | grep -vE "LS_COLORS|LESS_TERMCAP" | sort -f | column -t -s "=" -E 2'

lsmount() {
  ( echo "DEVICE PATH TYPE FLAGS" && mount | awk '$2="";1') | column -t
}

lscolors () {
  for i in {0..255}; do echo -e "\e[38;05;${i}m${i}"; done | column -c 180 -s ' '
}

# Grep from processer and list info with headers.
psg () {
  echo 'USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START    TIME COMMAND'
  ps aux | grep "$@" | grep -v grep
}

# Aliases for ls

alias sl='ls'

# note: --group-directories-first doesn't apply to symlinks.
if [[ $OSTYPE == 'darwin'* ]]; then
  alias lsa='ls -a' la='lsa'
  alias ll='ls -lg' lla='ll -a'
  alias lsd='ls -d' lld='lsd -l'
else
  alias lsa='ls --all' la='lsa'
  alias ll='ls --long --group' lla='ll --all'
  alias lsd='ls --list-dirs'   lld='lsd --long'
fi

alias .2="cd ../.." .3="cd ../../.."
alias .4="cd ../../../.." .5="cd ../../../../.."


# Package management {{{1

# find alternative apps if it is installed on your system
#find_alt() { for i;do which "$i" >/dev/null && { echo "$i"; return 0;};done;return 1; }

# Tämä lakkasi toimimasta jostain syystä.
#export MNGR=$(find_alt zypper aptitude apt-get)

#echo "Package Manager" $MNGR "detected."

if has rpm; then
  alias rpm-isot='rpm -qa --queryformat="%{NAME} %{VERSION} %{SIZE}\n" \
    | sort -k 3 -n | tail -n 100'
fi

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

if has zypper; then
  file="$HOME/.config/shells/zypper.sh"
  [[ -s "$file" ]] && source "$file"
fi

if [[ $OS == *fedora* ]]; then
  if [[ -d /sys/firmware/efi ]]; then
    file='grub2-efi.cfg'
  else
    file='grub2.cfg'
  fi
  alias update-grub="sudo grub2-mkconfig -o /etc/$file"
  dnf='sudo dnf'
  alias copr="$dnf copr"    \
        inf="dnf info"      \
        ins="$dnf install"  \
        list="dnf list --exclude '*i686'"  \
        lu="dnf check-update" \
        rem="$dnf remove"   \
        se="dnf search --exclude '*i686'"  \
        up="$dnf upgrade --refresh"
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
  if [[ "$XDG_SESSION_DESKTOP" == "plasma5" || "$XDG_SESSION_DESKTOP" == "KDE" ]]; then
    qdbus="qdbus org.kde.ksmserver /KSMServer logout"
    # Don't use shutdown on KDE but these:
    alias kpoweroff="$qdbus 0 2 0" \
          kreboot="$qdbus 0 1 0" \
          klogout="$qdbus 0 0 0" \
          restart-kwin='kwin_x11 --replace &>>/dev/null'
  elif [[ "$XDG_SESSION_DESKTOP" == "xfce" ]]; then
    # Change WM
    function xfce-wm () {
  #   if [[ -z "$1" ]]; then
  #        echo 'Usage : xfce-wm <wm_name>'
  #        echo 'Example: xfce-wm compiz'
  #      else
        xfconf-query -c xfce4-session -p /sessions/Failsafe/Client0_Command -t string -sa "$1"
        # Replace current window manager silently and disown the process.
        "$1" --replace &>/dev/null
      # fi
    }
  fi
fi

# vi:ft=sh
