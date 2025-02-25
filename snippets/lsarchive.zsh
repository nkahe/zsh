
# lsarchive.zsh is from Prezto but using 'zinit snippet' to include wasn't succesfull so
# local copy here is used instead.

#
# Lists the contents of archives.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

function lsarchive {

local verbose

if (( $# == 0 )); then
  cat >&2 <<EOF
usage: $0 [-option] [file ...]

options:
    -v, --verbose    verbose archive listing

Report bugs to <sorin.ionescu@gmail.com>.
EOF
fi

if [[ "$1" == "-v" || "$1" == "--verbose" ]]; then
  verbose=0
  shift
fi

while (( $# > 0 )); do
  if [[ ! -s "$1" ]]; then
    print "$0: file not valid: $1" >&2
    shift
    continue
  fi

  case "$1:l" in
    (*.tar.gz|*.tgz) tar t${verbose:+v}vzf "$1" ;;
    (*.tar.bz2|*.tbz|*.tbz2) tar t${verbose:+v}jf "$1" ;;
    (*.tar.xz|*.txz) tar --xz --help &> /dev/null \
      && tar --xz -t${verbose:+v}f "$1" \
      || xzcat "$1" | tar t${verbose:+v}f - ;;
    (*.tar.zma|*.tlz) tar --lzma --help &> /dev/null \
      && tar --lzma -t${verbose:+v}f "$1" \
      || lzcat "$1" | tar x${verbose:+v}f - ;;
    (*.tar.zst|*.tzst) tar -I zstd -t${verbose:+v}f "$1" ;;
    (*.tar) tar t${verbose:+v}f "$1" ;;
    (*.zip|*.jar) unzip -l${verbose:+v} "$1" ;;
    (*.rar) ( (( $+commands[unrar] )) \
      && unrar ${${verbose:+v}:-l} "$1" ) \
      || ( (( $+commands[rar] )) \
      && rar ${${verbose:+v}:-l} "$1" ) \
      || lsar ${verbose:+-l} "$1" ;;
    (*.7z) 7za l "$1" ;;
    (*)
      print "$0: cannot list: $1" >&2
      success=1
    ;;
  esac

  shift
done

}
