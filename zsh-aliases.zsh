#!/bin/zsh
# $ZDOTDIR/zsh-aliases.zsh
# Aliases and functions that only work in Z-shell.
# Both Zsh and Bash -compatible aliases are in ~/.config/shells/aliases.sh

# Misc {{{

# make less more friendly for non-text input files, see lesspipe(1)
# [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe export LESSOPEN="|﻿ /usr/share/source-highlight/sr­­c-hilite-lesspipe.sh %s"  # Ei oo asennettu.

function srf() {
  zle -I; surfraw $(cat ~/.config/surfraw/bookmarks | fzf |
    \ awk 'NF != 0 && !/^#/ {print $1}' ) ;
}

# fzf_surfraw() { zle -I; surfraw $(cat ~/.config/surfraw/bookmarks | fzf |
# \ awk 'NF != 0 && !/^#/ {print $1}' ) ; }; zle -N fzf_surfraw; bindkey '^W' fzf_surfraw

alias reload=load_personal_configs

 #}}}
# Functions {{{

# Edit Zsh config files. Usage: edz <part of filename>
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
function edz() {
    if has -v fzf; then
      local files=(${(f)"$(find $ZDOTDIR -iname "*$1*" | fzf --select-1 --exit-0)"})
      if [[ -n "$files" ]]; then
        $EDITOR -- "$files" && source "$files"
        print -l "$files[1]"
      fi
    else
      echo "fzf not found."
    fi
}

# copy/paste for linux machines (Mac style). by gotbletu
# demo video: http://www.youtube.com/watch?v=fKP0FLp3uW0

ck_check() {
  if [[  -z $1 || $1 == "--help" || $1 == "h" ]]; then
    echo "Usage: ck_check <english word(s)>\n"
    echo "Checks if your spelling is correct. If it's incorrect, it gives"
    echo "you suggestions for possible correct format. Needs 'aspell'."
  else
    if has aspell; then
      echo "$@" | aspell -a -l en
    else
      echo "aspell not found."
    fi
  fi
}

# Paste the selected entry from locate output into the command line
# https://github.com/junegunn/fzf/wiki/examples#changing-directory
# Ctrl-Alt-F (Find).
fzf-locate-widget() {
  local selected
  if selected=$(locate / | fzf -q "$LBUFFER"); then
    LBUFFER=$selected
  fi
  zle redisplay
}
zle     -N    fzf-locate-widget
bindkey -s '^[^F' fzf-locate-widget

# Automatically Expanding Global Aliases (Space key to expand)
# references: http://blog.patshead.com/2012/11/automatically-expaning-zsh-global-aliases---simplified.html
function globalias() {
  if [[ $LBUFFER =~ '[A-Z0-9]+$' ]]; then
    zle _expand_alias
    zle expand-word
  fi
  zle self-insert
}
zle -N globalias
bindkey " " globalias    # space key to expand globalalias
bindkey "^[[Z" magic-space            # shift-tab to bypass completion
bindkey -M isearch " " magic-space    # normal space during searches

# demo video: http://www.youtube.com/watch?v=Ww7Sl4d8F8A
# -a "käyttäjänimi", -b "serveri", -t "otsikko"
# http://ix.io
post-ix() { "$@" | curl -F 'f:1=<-' ix.io ;}

# Calculator
autoload -U zcalc
function __calculate {
  zcalc -e -f "$*"
}
aliases[ca]='noglob __calculate'

# Ctrl+Z key sequence in zsh to background the current job (%%). That way, I
# Send foreground job to background by pressing Ctrl+Z Ctrl+Z. when the current
# input line is not empty (so I haven't just come back from a subprocess):
# “suspend” the current input line, allowing me to type another command, after
# which the interrupted line is pushed back into the input buffer.
function fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then   # Check if input line is empty.
    bg
    zle redisplay
  else
    zle push-input
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

#}}}
# Tietoa järjestelmästä {{{

# psg=' ps aux | head -n 1; ps aux | grep --invert-match grep | grep'

alias lsfpath='echo -e ${FPATH//:/\\n}'  # List $FPATH (zsh functions path) nicely

alias history=' fc -El 1 |tail -n 100'

#alias tv="w3m -dump http://www.iltapulu.fi/\?timeframe\=2 | awk '/tv-ohjelmat/,/^$/'"  pipetys sekoaa tästä.

# Sääennuste 5pv
# sää5 () { w3m -dump http://ilmatieteenlaitos.fi/saa/oulu\?map\=weathertomorrow\&parameter\=4\&station\=101794 | awk '/Paikallissää Oulu/,/Suomen varoitukset/' ;}
# Sää nyt.
# sää () { w3m -dump http://ilmatieteenlaitos.fi/saa/oulu\?map\=weathertomorrow\&parameter\=4\&station\=101794 | sed -n '50,60p' | sed '/Muuntolaskuri/d' ;}

# tldr-pages: Node.js command line client for TLDR-pages -> https://github.com/tldr-pages/tldr-node-client
# alias tldr='tldr --linux -t ocean'

# Etsii cmdfu:sta tietoa, by Gotbletu.
function cmdfu() {
  curl "https://www.commandlinefu.com/commands/matching/$(echo "$@" \
  | sed 's/ /-/g')/$(echo -n $@ | base64)/plaintext";
}

# File operations {{{1

# FIXME: doesn't work.
alias lsl='ls -d *(@)' \
      lll='ls -dl *(@)'

# Make new dir and change to it.
function mkcd() {
  nocorrect mkdir -p "$1" && cd "$1";
}

# Don't use autocorrect with these commands + some better default flags..
alias sudo='nocorrect sudo'
alias touch='nocorrect touch'
alias ln='nocorrect ln'
alias mv='nocorrect mv -v'
alias mkdir='nocorrect mkdir -vp'

# Finding files {{{1

# Locate -komennosta parempi versio. Voi laittaa 'foo bar (bla1|bla2)  	    by Gotbletu'
function sef () {
  keyword=$(echo "$@" | sed 's/ /.*/g' | sed 's:|:\\:g' | sed 's:(:\\(:g' | sed 's:):\\):g')
  # Do not results from backup -directory
  locate --ignore-case $keyword | less
}

function sef-fzf() {
  xdg-open "$(locate --ignore-case --existing $@"*" | fzf -e)";
}

# starts one or multiple args as programs in background. Used with suffix aliases.
background() {
  for ((i=2; i<=$#; i++)); do
    ${@[1]} ${@[$i]} &> /dev/null &
  done
}

##### Global and suffix aliases ##### {{{

# Mac aliases for WOL.
alias -g I7='e0:69:95:2e:93:98' HPPRO='38:63:bb:bb:f0:36' RYZEN='18:c0:4d:99:88:11'
alias -g C='column' G='grep' H='head' L='less' M='most' S='sort' T='tail'
alias -g DN='/dev/null'
# For DNF
alias -g NW='--setopt=install_weak_deps=False'

# global aliases
alias -g SU='--suggested' NR='--no-recommends' D='--details'

###### Suffix -aliases. #####

# Don't add .zsh
alias -s {avi,flv,mkv,mp4,mpeg,mpg,ogv,wmv}="background $VIDEOPLAYER"
alias -s {flac,mp3,ogg,wav}="background $AUDIOPLAYER"
alias -s {gif,GIF,jpeg,JPEG,jpg,JPG,png,PNG}="background $IMAGEVIEWER"
alias -s {ctb,doc,docx,pdf,ods,odt,rtf,ppt,pptx,torrent,iso,jarwav,xls,xml}="background xdg-open"
alias -s {conf,css,html,js,md,muttrc,txt,vim,zsh}="background $EDITOR"
alias -s pdf="background $PDFVIEWER" ace="unace l" rar="unrar l"
alias -s {tar,bz2,gz,xz}="tar tvf"	#tar.bz2,tar.gz,tar.xz
alias -s zip="unzip -l | less"

#}}}
#}}}
