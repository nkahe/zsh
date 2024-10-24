#!/bin/zsh
# $ZDOTDIR/zsh-aliases.zsh
# Aliases and functions that only work in Z-shell.
# Both Zsh and Bash -compatible aliases are in ~/.config/shells/aliases.sh

# Misc {{{

# make less more friendly for non-text input files, see lesspipe(1)
# [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe export LESSOPEN="|﻿ /usr/share/source-highlight/sr­­c-hilite-lesspipe.sh %s"  # Ei oo asennettu.

# Reload Zsh user settings.
alias reload="source $ZDOTDIR/.{zprofile,zshrc}"

zox_fzf_widget() {
  # Save the currently typed characters into a variable
  local query="$LBUFFER"

  # Use fzf to search in the Zoxide database, pre-filtered by the typed characters
  local dir=$(zoxide query -ls | awk '{print $2}' | fzf --query="$query" --height 40% --reverse --inline-info)

  # If a directory is selected, replace the current command line buffer with 'cd' to that directory
  if [[ -n $dir ]]; then
    LBUFFER="cd '$dir'"
    zle accept-line  # Simulate pressing Enter to execute the command
  fi
}

# Bind Ctrl-G to the custom widget
zle -N zox_fzf_widget
bindkey '^G' zox_fzf_widget

# Search in Surfraw bookmarks using Fzf. Note: surfraw has native alias "sr".
if has srf; then
  function srfb() {
    zle -I; surfraw $(cat ~/.config/surfraw/bookmarks | fzf |
      \ awk 'NF != 0 && !/^#/ {print $1}' ) ;
  }
fi

# fzf_surfraw() { zle -I; surfraw $(cat ~/.config/surfraw/bookmarks | fzf |
# \ awk 'NF != 0 && !/^#/ {print $1}' ) ; }; zle -N fzf_surfraw; bindkey '^W' fzf_surfraw

 #}}}
# Functions {{{

# Automatically show files after directory change.
if has eza; then
  chpwd() { eza --group-directories-first ;}
else
  if [[ $OSTYPE == 'darwin'* ]]; then
    chpwd() { ls -c ;}
  else
    chpwd() { ls --color ;}
  fi
fi

# Edit Zsh config files. Usage: edz <part of filename>
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
function edz() {
  if has fzf; then
    local files=(${(f)"$(find $ZDOTDIR -iname "*$1*" | fzf --select-1 --exit-0)"})
    if [[ -n "$files" ]]; then
      $EDITOR -- "$files" && source "$files"
      print -l "$files[1]"
    fi
  else
    echo "fzf not found."
  fi
}

function check() {
  if [[  -z $1 || $1 == "--help" || $1 == "h" ]]; then
    echo "Usage: check <english word(s)>\n"
    echo "Checks if your spelling is correct. If it's incorrect, it gives"
    echo "you suggestions for possible correct format. Needs 'aspell'."
  else
    if has aspell; then
      echo "$@" | aspell -a --lang=en
    else
      echo "aspell not found."
    fi
  fi
}

# Paste the selected entry from locate output into the command line
# https://github.com/junegunn/fzf/wiki/examples#changing-directory
# Ctrl-Alt-F (Find).
function fzf-locate-widget() {
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
function post-ix() { "$@" | curl -F 'f:1=<-' ix.io ;}

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

alias lshist=' fc -El 1 | tail -n 100'

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
function mkdcd() {
  nocorrect mkdir --parents "$1" && cd "$1";
}

# Don't use autocorrect with these commands + some better default flags..
alias sudo='nocorrect sudo'
alias touch='nocorrect touch'
alias ln='nocorrect ln'
alias mv='nocorrect mv --verbose'
alias mkdir='nocorrect mkdir --verbose --parents'

# Finding files {{{1

# Locate with Fzf. Original script by Gotbletu.
# You can enter searches: foo bar (bla1|bla2)
function flocate () {
  keyword=$(echo "$@" | sed 's/ /.*/g' | sed 's:|:\\:g' | sed 's:(:\\(:g' | sed 's:):\\):g')
  # Do not results from backup -directory
  locate --ignore-case --limit 500 $keyword | fzf
}

function flocate-open() {
  xdg-open "$(locate --ignore-case --existing $@"*" | fzf -e)";
}

# starts one or multiple args as programs in background. Used with suffix aliases.
function background() {
  for ((i=2; i<=$#; i++)); do
    ${@[1]} ${@[$i]} &> /dev/null &
  done
}

##### Global and suffix aliases ##### {{{

alias -g C='column' G='grep' H='head' L='less' S='sort' T='tail'
alias -g DN='/dev/null'
# For DNF
alias -g NW='--setopt=install_weak_deps=False'

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
