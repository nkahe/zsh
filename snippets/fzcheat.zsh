#!/bin/sh
# Search Cheat -cheatsheets with Fzf.

if ! command -v cheat &>/dev/null; then
  return
fi

if ! command -v fzf &>/dev/null; then
  alias cs=cheat
  return
fi

function fzcheat() {
  local fzf_args=( -d ':' --ansi --with-nth '2..'
                   --bind 'ctrl-y:execute-silent(echo {1} | clip)'
                   --bind 'alt-e:execute(cheat -e {1})'
                   --bind 'ctrl-m:execute:cheat -c {1} | $PAGER'
                   --bind 'enter:accept'
                  )
  local selection
  [ -z "$*" ] || fzf_args+=( -q "$*" )
  selection=$(cheat -l |
    awk -v c_tag_l=$'\e[1m' \
        -v c_tag_r=$'\e[0m' \
        -e 'NR == 1 { next }' \
        -e '{
  tags=""
  for (i=3; i <= NF; i++) {
    tags = $i FS
  }
  sub(FS "$", "", tags)
  printf("%s:%s%s\n", $1, $1, tags ? (c_tag_l " [" tags "] " c_tag_r) : "")
}' |
    fzf "${fzf_args[@]}")

  [[ -z "$selection" ]] && return
  cheat "${selection%%:*}"
}

# cs is alias for cheat,  use fzf if "-s" parameter is given without other parameters.
function cs() {
  if (( $# == 1 )) && [[ $1 == -s ]]; then
    fzcheat
    return
  fi
  cheat "$@"
}
