# These aliases and functions only work with X11

# This file is not currently sourced.

# Xorg could be detected like this:

# if [[ -n "$WAYLAND_DISPLAY" ]]; then
# 	echo "Running under Wayland"
# elif [[ -n "$DISPLAY" && (pgrep -x Xorg || pgrep -x X) ]]; then
# 	echo "Running under X11"
# else
# 	echo "Not running under X11 or Wayland"
# fi

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
  cpwd() {
    pwd | tr -d "\r\n" | xclip -selection clipboard
  }

  # Copy file's (relational) path to clipboard
  cppath() {
    readlink --canonicalize "$1" | xclip -selection clipboard
  }

  # Same with absolute file path.
  cprealpath() {
    realpath "$1" | xclip -selection clipboard
  }
}

has obxprop && alias obxp='echo Click a window; obxprop | grep "^_OB_APP"'
  # Show window name and class.
if has xprop; then
  alias xp='echo Click a window; xprop | grep "WM_WINDOW_ROLE\|WM_CLASS" && \
  echo "WM_CLASS(STRING) = \"NAME\", \"CLASS\""'
fi

# Näyttö pois päältä
function moff () {
  xset dpms force off
}
function lid-off () {
  xrandr --output LVDS1 --off
}

function lid-on () {
  xrandr --output LVDS1 --on
}

has xbindkeys && alias xbindkeys="xbindkeys -f $HOME/.config/xbindkeysrc"

has xclip && xclip_aliases

# Turn Caps Lock to Ctrl if don't use keyd.
#
# alias caps-ctrl='setxkbmap -option "ctrl:nocaps"'
# alias caps-esc='setxkbmap -option "caps:escape"'
# alias caps-esc='setxkbmap -option "caps:swapescape"'
