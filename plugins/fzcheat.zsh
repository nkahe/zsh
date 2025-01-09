#!/bin/zsh

#historyfile="${XDG_DATA_HOME:-$HOME/.local/share}"/fzf/history/fzf_cheat

# Need to make the dir too.
# if [[ ! -f $historyfile ]]; then
  # touch $historyfile
# fi

# Add flag to enable history
                   # --history $historyfile

function fzcheat() {
  local fzf_args=( -d ':' --ansi --with-nth '2..'
                   --bind 'ctrl-y:execute-silent(echo {1} | clip)'
                   --bind 'alt-e:execute(cheat -e {1})'
                   --bind 'ctrl-m:execute:cheat -c {1} | $PAGER'
                   --bind 'enter:execute:cheat {1}'
                  )
  [ -z "$*" ] || fzf_args+=( -q "$*" )

  cheat -l |
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
    fzf "${fzf_args[@]}"
}
