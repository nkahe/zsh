# This file is for common aliases compatible for Zsh, Bash and Fish -shells.

alias game="kscreen-doctor output.DP-1.mode.12"
alias normal="kscreen-doctor output.DP-1.mode.2"

# Extra applications {{{1

alias restart-xdg='systemctl --user restart plasma-xdg-desktop-portal-kde'

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
alias e="$editor"

if has eza; then
  alias ls="eza --group-directories-first --color=always --icons"
elif has exa; then
 alias ls="exa --group-directories-first --color=always --icons"
fi

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
# alias run-trayer='trayer --edge bottom --align right --widthtype request --heighttype pixel --height 34 --SetDockType true --transparent true --alpha 90 --tint blue --monitor 1 --padding 10'

# https://github.com/lord63/tldr.py
# lord63/tldr.py: A python client for tldr: simplified and community-driven man pages.
has gio && alias tldrf='/usr/bin/tldr find'

if has gio; then
  # Put files to trash
  alias pt="gio trash" trash-empty='gio trash --empty'
fi

alias termbin="nc termbin.com 9999"

# kuvan jakaminen tähän palveluun jotenkin?
# https://imgbb.com/upload

# pipetys sekoaa tästä.
#alias tv="w3m -dump http://www.iltapulu.fi/\?timeframe\=2 | awk '/tv-ohjelmat/,/^$/'"

alias wttr=' curl http://wttr\.in/Oulu'

has yank-cli && alias yank=yank-cli

# Functions {{{1

# Print alphabets
alp() {
  for x in {A..Z} ; do
    printf $x" "
  done
  echo "Å Ä Ö"
}

html-to-md () {
 find . -iname "*.html" -type f -exec sh -c \
  'pandoc -s -r html -t markdown_strict "${0}" -o "${0%.html}.md"' {} \;
}

# Wayland Tools ---------------------------------------------------------------

# Copy working directory to clipboard. Needs wl-clipboard.
if has wl-copy; then
  cpwd() {
    pwd | tr -d "\r\n" | wl-copy
  }
fi

# -----------------------------------------------------------------------------

irc() {
  ssh -tt $USER@rasp screen -rdU
}

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

# Open file with associated program silently.
 # Huom. jos laittaa & perään, niin oletuksena bg jobeilla on pienempi prioriteetti.
 # You can turn this feature off by setting NO_BG_NICE.

# For non-root users.
if [[ $UID != 0 ]]; then
  #alias mount='sudo mount'
  #alias umount='sudo umount'
  alias updatedb='sudo updatedb'
fi

# Add additional default flags

alias chmod="chmod $cflags" chown="chown $cflags"
alias dd='dd status=progress'

# Mac versions has some different flags.
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

# Abbrevations

alias p="$PAGER"
alias sctl='systemctl'
alias jctl='journalctl'
alias his=' history'
alias xo='xdg-open'

# allows you to create and view interactive sheets on the command-line.
# https://github.com/cheat/cheat. cs is short for cheatsheet
has cheat && alias cs='cheat'

# Handy aliases

# Työhakemistossa olevien hakemistojen viemä tila.
alias du1='du --max-depth=1 | sort --numeric-sort'
# Ei alihakemistojen kokoa.
alias dud='du --separate-dirs | sort --numeric-sort --reverse'
alias logoff='loginctl terminate-session $XDG_SESSION_ID'
alias susp='systemctl suspend'

# List things more nicely.

alias lspath='echo -e ${PATH//:/\\n}'
# Hakemistojen viemä tila. Ei alihakemistojen kokoa.
# Ei toimi edellisen aliaksen kanssa.  pitäis korjata.
alias lsip='ip -brief -family inet addr'
alias lsenv='env | grep -vE "LS_COLORS|LESS_TERMCAP" | sort -f | column -t -s "=" -E 2'

lsmount() {
  echo "DEVICE PATH TYPE FLAGS"
  mount | awk '$2="";1' | column -t
}

# List 256 foreground colors. There's separate script file for background colors.
lscolors () {
  for i in {0..255}
    do echo -e "\e[38;05;${i}m${i}"
  done | column -c 180 -s ' '
}

# Grep from processer and list info with headers.
psg () {
  echo 'USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START    TIME COMMAND'
  ps aux | grep "$@" --color=always | grep -v grep
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

function update-grub-alias() {
  if [[ -d /sys/firmware/efi ]]; then
    file='grub2-efi.cfg'
  else
    file='grub2.cfg'
  fi
  alias update-grub="sudo grub2-mkconfig -o /etc/$file"
}

if has zypper; then
  file="$HOME/.config/shells/zypper.sh"
  [[ -s "$file" ]] && source "$file"
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
