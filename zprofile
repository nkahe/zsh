# vim: ft=bash
# Executes commands at login shells pre-zshrc, e.g. at system startup.
# /etc/zprofile gets executed before this.
# settings in /etc/zshrc can override these.
#
# Don't put anything that outputs text here. Can break things like ssh and scp.
#
# NOTE: No Zsh-only syntax. This file is linked to ~/.profile and is sourced
# from Bash too.

# If terminal is set to xterm, set 256 color mode.
if [[ $TERM == xterm || $TERM == xterm-color ]]; then
  export TERM=xterm-256color
fi

# Path
[[ -d $HOME/bin ]] && export PATH="$PATH:$HOME/bin"
[[ -d $HOME/.local/bin ]] && export PATH="$PATH:$HOME/.local/bin"
[[ -d $HOME/scripts ]] && export PATH="$PATH:$HOME/scripts"

export GEM_HOME="$HOME/.local/rubygems"
[[ -d $GEM_HOME ]] && export PATH="$PATH:$GEM_HOME/bin"


# Check if a command exists.
function has() {
  command -v "$@" &> /dev/null
}

export OPENAI_CONFIG_HOME=$HOME/.config
export OPENAI_DATA_HOME=$HOME/.local/share

## Plugins

# Zsh Autosuggestions
# export region_highlight=''
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion) 
# # Avoid triggering suggestions when pasting large amount of text in the terminal.
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30
# # Don't suggest anything longer than this amount of characters.
export ZSH_AUTOSUGGEST_HISTORY_IGNORE="?(#c80,)"

# Ensure zsh-vi-mode initializes after other keybindings
export ZVM_INIT_MODE=sourcing
export ZVM_SYSTEM_CLIPBOARD_ENABLED=true

# Ignore saving these to history file.
export HISTORY_IGNORE="(cd -|cd ..|ls|ll|la|pwd|exit|history|trfi*|tren*)"

# Zsh-sage. https://github.com/UtsavMandal2022/zsh-sage
export ZSH_SAGE_COLOR_HIGH=247     # light grey
export ZSH_SAGE_COLOR_MED=244      # medium grey
export ZSH_SAGE_COLOR_LOW=241      # faint grey

# Editor settings

# Default text editor
if has nvim; then
  EDITOR="nvim"
  if [[ -d $HOME/.config/nvim/custom ]]; then
    export NVIM_APPNAME="nvim/custom"
  fi
elif has micro; then
  EDITOR="micro"
else
  EDITOR="nano"
fi

export EDITOR
export SYSTEMD_EDITOR=$EDITOR
export VISUAL=$EDITOR

# has qimgv && export IMAGEVIEWER='qimgv'
# has zathura && export PDFVIEWER='zathura'
# export AUDIOPLAYER="xdg-open"

# Pager

# moor pager is installed as zinit -plugin so it's executable is not
# available when this file is sourced.
# if has moar; then
  export PAGER='moor'
  export MOOR='-style github-dark -quit-if-one-screen'
# elif has most; then
#   export PAGER='most'
# else
#   export PAGER='less'
# fi

if has nvimpager; then
  export MANPAGER='nvimpager'
fi

if has bat; then
  # export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  # It might be necessary to set MANROFFOPT="-c" if  experience formatting problems.
  export MANROFFOPT="-c"
  export BAT_THEME='Visual Studio Dark+'
fi

# Sets env variables for Brew.
if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

export GREP_COLORS='ms=01;36:mc=01;31:sl=37:cx=01;33:fn=34:ln=94:bn=32:se=36'

# Less  ------------------------------------------------------------------------

# Termcap is defined in PZT::modules--environment

if [[ -f ${XDG_CONFIG_HOME:-${HOME}/.config}/lesskey ]]; then
  configfile="--lesskey-file ${XDG_CONFIG_HOME:-${HOME}/.config}/lesskey"
else
  configfile=''
fi

export LESS="--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen \
  --RAW-CONTROL-CHARS $configfile"
cachedir="${XDG_CACHE_HOME:-$HOME/.cache}"

# Used by OMZ plugins like last-working-dir and completions.
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ ! -d "$ZSH_CACHE_DIR" ]] && mkdir -p "$ZSH_CACHE_DIR"

export LESSHISTFILE="$cachedir/.less_history"

if [[ ! -f "$LESSHISTFILE" ]]; then
  if [[ ! -d "$cachedir" ]]; then
    mkdir -p "$cachedir"
  fi
  :>"$LESSHISTFILE"
fi
unset cachedir configfile

# Other application ------------------------------------------------------------

# NPM: no annoying messages about new versions (package manager handles it).
if has npm; then
  export NO_UPDATE_NOTIFIER
fi

# dir="$HOME/.local/state"
# [[ ! -d "$dir" ]] && mkdir -p "$dir"
# file="$dir/.node_repl_history"
# export NODE_REPL_HISTORY="$file"
# unset dir file

has cheat && export CHEAT_USE_FZF=true

# FZF by default starts in fullscreen mode, but you can make it start below the cursor
# with --height option.
has fzf && export FZF_DEFAULT_OPTS='--height 40%'

# export FZF_ALT_C_COMMAND='^[d'

# TLDR
if has tldr; then
  # tldr installed with pip. https://pypi.org/project/tldr/
  export TLDR_COLOR_BLANK="cyan"
  export TLDR_COLOR_NAME="green"
  export TLDR_COLOR_DESCRIPTION="cyan"
  # Example tells what command does.
  export TLDR_COLOR_EXAMPLE="white"
  export TLDR_COLOR_COMMAND="blue"
  export TLDR_COLOR_PARAMETER="cyan"
  export TLDR_CACHE_ENABLED=1
  export TLDR_CACHE_MAX_AGE=720
fi

# Got error without this:
# zvm_zle-line-pre-redraw:5: TMUX: parameter not set
${TMUX:=}
export TMUX

# Linux utility to configure modifier keys to act as other keys when presse

if has wget; then
  export WGETRC=${XDG_CONFIG_HOME:-$HOME/.config}/wgetrc
fi

export _ZO_DATA_DIR="$HOME/.local/state/zsh"
[[ ! -d "$_ZO_DATA_DIR" ]] && mkdir -p "$_ZO_DATA_DIR"

LS_COLORS='*.1p=38;5;7:*.32x=38;5;213:*.3g2=38;5;115:*.3ga=38;5;137;1:*.3gp=38;5;115:*.3p=38;5;7:*.7z=38;5;40:*.82p=38;5;121:*.83p=38;5;121:*.8eu=38;5;121:*.8xe=38;5;121:*.8xp=38;5;121:*.a00=38;5;213:*.a=38;5;40:*.a52=38;5;213:*.a64=38;5;213:*.A64=38;5;213:*.a78=38;5;213:*.aac=38;5;137;1:*.accdb=38;5;60:*.accde=38;5;60:*.accdr=38;5;60:*.accdt=38;5;60:*.adf=38;5;213:*.adoc=38;5;184:*.afm=38;5;66:*.agda=38;5;81:*.agdai=38;5;110:*.ahk=38;5;41:*.ai=38;5;99:*.aiff=38;5;136;1:*.alac=38;5;136;1:*.allow=38;5;112:*.am=38;5;242:*.amr=38;5;137;1:*.ape=38;5;136;1:*.apk=38;5;215:*.application=38;5;116:*.aria2=38;5;241:*.arj=38;5;40:*.asc=38;5;192;3:*.asciidoc=38;5;184:*.asf=38;5;115:*.asm=38;5;81:*.ass=38;5;117:*.astro=38;5;135;1:*.atr=38;5;213:*.au=38;5;137;1:*authorized_keys=1:*AUTHORS=38;5;220;1:*.automount=38;5;45:*.avi=38;5;114:*.awk=38;5;172:*.azw3=38;5;141:*.azw=38;5;141:*.bak=38;5;241:*.bash=38;5;172:*.bash_login=1:*.bash_logout=1:*.bash_profile=1:*.bat=38;5;172:*.BAT=38;5;172:*.bfe=38;5;192;3:*.bib=38;5;178:*.bin=38;5;124:bd=38;5;68:*.bmp=38;5;97:*.br=38;5;40:*.bsp=38;5;215:*.BUP=38;5;241:*.bz2=38;5;40:*.c=38;5;81:*.c++=38;5;81:*.C=38;5;81:*.cab=38;5;215:*.caf=38;5;137;1:*.cap=38;5;29:ca=38;5;17:*.car=38;5;57:*.cbr=38;5;141:*.cbz=38;5;141:*.cc=38;5;81:*.cda=38;5;136;1:*.cdi=38;5;213:*.cdr=38;5;97:*cfg=1:*.CFUserTextEncoding=38;5;239:*CHANGELOG=38;5;220;1:*CHANGELOG.md=38;5;220;1:*CHANGES=38;5;220;1:*.chm=38;5;141:cd=38;5;113;1:*.cjs=38;5;074;1:*.cl=38;5;81:*.clj=38;5;41:*.cljc=38;5;41:*.cljs=38;5;41:*.cljw=38;5;41:*.cnc=38;5;7:*CODEOWNERS=38;5;220;1:*CodeResources=38;5;239:*.coffee=38;5;079;1:*.comp=38;5;136:*conf=1:*config=1:*Containerfile=38;5;155:*.containerignore=38;5;240:*CONTRIBUTING=38;5;220;1:*CONTRIBUTING.md=38;5;220;1:*CONTRIBUTORS=38;5;220;1:*COPYING=38;5;220;1:*COPYRIGHT=38;5;220;1:*core=38;5;241:*.cp=38;5;81:*.cpio=38;5;40:*.cpp=38;5;81:*.cr=38;5;81:*.crx=38;5;215:*.cs=38;5;81:*.css=38;5;105;1:*.csv=38;5;78:*.ctp=38;5;81:*.cue=38;5;116:*.cxx=38;5;81:*.dart=38;5;51:*.dat=38;5;137;1:*.db=38;5;60:*.deb=38;5;215:*.def=38;5;7:*.deny=38;5;196:*.description=38;5;116:*.device=38;5;45:*.dhall=38;5;178:*.dicom=38;5;97:*.diff=48;5;197;38;5;232:di=38;5;39:*.directory=38;5;116:*.divx=38;5;114:*.djvu=38;5;141:*.dll=38;5;241:*.dmg=38;5;215:*.dmp=38;5;29:*.doc=38;5;111:*Dockerfile=38;5;155:*.dockerignore=38;5;240:*.docm=38;5;111;4:*.docx=38;5;111:do=38;5;127:*.drw=38;5;99:*.DS_Store=38;5;239:*.dtd=38;5;178:*.dts=38;5;137;1:*.dump=38;5;241:*.dwg=38;5;216:*.dylib=38;5;241:*.ear=38;5;215:*.ejs=38;5;135;1:*.el=38;5;81:*.elc=38;5;241:*.eln=38;5;241:*.eml=38;5;90;1:*.enc=38;5;192;3:*.entitlements=1:*.epf=1:*.eps=38;5;99:*.epsf=38;5;99:*.epub=38;5;141:*.err=38;5;160;1:*.error=38;5;160;1:*.etx=38;5;184:*.ex=38;5;7:*.example=38;5;7:ex=38;5;208;1:*.f4v=38;5;115:*.fb2=38;5;141:*.fcm=38;5;137;1:*.feature=38;5;7:pi=38;5;126:fi=38;5;14:*.fish=38;5;172:*.flac=38;5;136;1:*.flif=38;5;97:*.flv=38;5;115:*.fm2=38;5;213:*.fmp12=38;5;60:*.fnt=38;5;66:*.fon=38;5;66:*.fp7=38;5;60:*.frag=38;5;136:*.fvd=38;5;124:*.fxml=38;5;178:*.gb=38;5;213:*.gba=38;5;213:*.gbc=38;5;213:*.gbr=38;5;7:*.gel=38;5;213:*.gemspec=38;5;41:*.ger=38;5;7:*.gg=38;5;213:*.ggl=38;5;213:*.gif=38;5;97:*.git=38;5;197:*.gitattributes=38;5;240:*.github=38;5;197:*.gitignore=38;5;240:*.gitmodules=38;5;240:*.go=38;5;81:*.gp3=38;5;115:*.gp4=38;5;115:*.gpg=38;5;192;3:*.gs=38;5;81:*.gz=38;5;40:*.h=38;5;110:*.h++=38;5;110:*.H=38;5;110:*.hi=38;5;110:*.hidden-color-scheme=1:*.hidden-tmTheme=1:*.hin=38;5;242:*HISTORY=38;5;220;1:*.hjson=38;5;178:*.hpp=38;5;110:*.hs=38;5;81:*.htm=38;5;125;1:*.html=38;5;125;1:*.http=38;5;90;1:*.hxx=38;5;110:*.icns=38;5;97:*.ico=38;5;97:*.ics=38;5;7:*id_dsa=38;5;192;3:*id_ecdsa=38;5;192;3:*id_ed25519=38;5;192;3:*id_rsa=38;5;192;3:*.IFO=38;5;114:*.ii=38;5;110:*.img=38;5;124:*.iml=38;5;166:*.in=38;5;242:*.info=38;5;184:*.ini=1:*INSTALL=38;5;220;1:*.ipa=38;5;215:*.ipk=38;5;213:*.ipynb=38;5;41:*.iso=38;5;124:*.j64=38;5;213:*.jad=38;5;215:*.jar=38;5;215:*.java=38;5;079;1:*.jhtm=38;5;125;1:*.jpeg=38;5;97:*.jpg=38;5;97:*.JPG=38;5;97:*.js=38;5;074;1:*.jsm=38;5;079;1:*.json=38;5;178:*.json5=38;5;178:*.jsonc=38;5;178:*.jsonl=38;5;178:*.jsonnet=38;5;178:*.jsp=38;5;079;1:*.jsx=38;5;074;1:*.jxl=38;5;97:*.kak=38;5;172:*.key=38;5;166:*known_hosts=1:*.lagda=38;5;81:*.lagda.md=38;5;81:*.lagda.rst=38;5;81:*.lagda.tex=38;5;81:*.last-run=1:*.less=38;5;105;1:*.lhs=38;5;81:*.libsonnet=38;5;142:*LICENSE=38;5;220;1:*LICENSE.md=38;5;220;1:ln=target:*.lisp=38;5;81:*.lnk=38;5;39:*.localized=38;5;239:*.localstorage=38;5;60:*lock=38;5;248:*lockfile=38;5;248:*.log=38;5;190:*.lrz=38;5;40:*LS_COLORS=48;5;89;38;5;197;1;3;4;7:*.lua=38;5;81:*.lz=38;5;40:*.lzma=38;5;40:*.lzo=38;5;40:*.m2v=38;5;114:*.m=38;5;110:*.M=38;5;110:*.m3u=38;5;116:*.m3u8=38;5;116:*.m4=38;5;242:*.m4a=38;5;137;1:*.m4v=38;5;114:*Makefile=38;5;155:*MANIFEST=38;5;243:*.map=38;5;7:*.markdown=38;5;184:*.md=38;5;184:*.md5=38;5;116:*.mdb=38;5;60:*.mde=38;5;60:*.mdump=38;5;241:*.mdx=38;5;184:*.merged-ca-bundle=1:*.mf=38;5;7:*.mfasl=38;5;7:*.mht=38;5;125;1:*.mi=38;5;7:*.mid=38;5;136;1:*.midi=38;5;136;1:*.mjs=38;5;074;1:*.mkd=38;5;184:*.mkv=38;5;114:*.ml=38;5;81:*.mm=38;5;7:*.mobi=38;5;141:*.mod=38;5;137;1:*.moon=38;5;81:*.mount=38;5;45:*.mov=38;5;114:*.MOV=38;5;114:*.mp3=38;5;137;1:*.mp4=38;5;114:*.mp4a=38;5;137;1:*.mpeg=38;5;114:*.mpg=38;5;114:*.msg=38;5;178:*.msql=38;5;222:*.mtx=38;5;7:mh=38;5;222;1:*.mustache=38;5;135;1:*.mysql=38;5;222:*.nc=38;5;60:*.ndjson=38;5;178:*.nds=38;5;213:*.nes=38;5;213:*.nfo=38;5;184:*.nib=38;5;57:*.nim=38;5;81:*.nimble=38;5;81:*.nix=38;5;155:*.norg=38;5;184:no=0:*NOTICE=38;5;220;1:*.nrg=38;5;124:*.nth=38;5;97:*.numbers=38;5;112:*.o=38;5;241:*.odb=38;5;111:*.odp=38;5;166:*.ods=38;5;112:*.odt=38;5;111:*.oga=38;5;137;1:*.ogg=38;5;137;1:*.ogm=38;5;114:*.ogv=38;5;115:*.old=38;5;242:*.opus=38;5;137;1:*.org=38;5;184:*.orig=38;5;241:or=38;5;203;1:*.otf=38;5;66:ow=38;5;220;1:*.out=38;5;242:*.p12=38;5;192;3:*.p7s=38;5;192;3:*.pacnew=38;5;33:*.pages=38;5;111:*.pak=38;5;215:*.part=38;5;239:*.patch=48;5;197;38;5;232;1:*PATENTS=38;5;220;1:*.path=38;5;45:*.pbxproj=1:*.pc=38;5;7:*.pcap=38;5;29:*.pcb=38;5;7:*.pcf=1:*.pcm=38;5;136;1:*.pdf=38;5;141:*.PDF=38;5;141:*.pem=38;5;192;3:*.pfa=38;5;66:*.PFA=38;5;66:*.pfb=38;5;66:*.pfm=38;5;66:*.pgn=38;5;178:*.pgp=38;5;192;3:*.pgsql=38;5;222:*.php=38;5;81:*.pi=38;5;7:*.pid=38;5;248:*.pk3=38;5;215:*PkgInfo=38;5;239:*.PL=38;5;160:*.pl=38;5;208:*.plist=1:*.plt=38;5;7:*.ply=38;5;216:*.pm=38;5;203:*pm_to_blib=38;5;240:*.png=38;5;97:*.pod=38;5;184:*.pot=38;5;7:*.pps=38;5;166:*.ppt=38;5;166:*.ppts=38;5;166:*.pptsm=38;5;166;4:*.pptx=38;5;166:*.pptxm=38;5;166;4:*.prisma=38;5;222:*.profile=1:*.properties=38;5;116:*.prql=38;5;222:*.ps=38;5;99:*.psd=38;5;97:*.psf=1:*.pug=38;5;135;1:*.pxd=38;5;97:*.pxm=38;5;97:*.py=38;5;41:*.pyc=38;5;240:*.qcow=38;5;124:*.r[0-9]{0,2}=38;5;239:*.r=38;5;49:*.R=38;5;49:*.rake=38;5;155:*.rar=38;5;40:*.rb=38;5;41:*rc=1:*.rdata=38;5;178:*.RData=38;5;178:*.rdf=38;5;7:*README=38;5;220;1:*README.md=38;5;220;1:*README.rst=38;5;220;1:*.rego=38;5;178:*.rkt=38;5;81:*.rlib=38;5;241:*.rmvb=38;5;114:*.rnc=38;5;178:*.rng=38;5;178:*.rom=38;5;213:*.rpm=38;5;215:*.Rproj=38;5;11:*.rs=38;5;81:*.rss=38;5;178:*.rst=38;5;184:*.rstheme=1:*.rtf=38;5;111:*.ru=38;5;7:*.s=38;5;110:*.S=38;5;110:*.s3m=38;5;137;1:*.S3M=38;5;137;1:*.s7z=38;5;40:*.sample=38;5;114:*.sass=38;5;105;1:*.sassc=38;5;244:*.sav=38;5;213:*.sc=38;5;41:*.scala=38;5;41:*.scan=38;5;242:*.sch=38;5;7:*.scm=38;5;7:*.scpt=38;5;219:*.scss=38;5;105;1:*.sed=38;5;172:*@.service=38;5;45:*.service=38;5;45:sg=48;5;3;38;5;0:su=38;5;220;1;3;100;1:*.sfv=38;5;116:*.sgml=38;5;178:*.sh=38;5;172:*.sid=38;5;137;1:*.sig=38;5;192;3:*.signature=38;5;192;3:*.sis=38;5;7:*.SKIP=38;5;244:*.sms=38;5;213:*.snapshot=38;5;45:so=38;5;197:*.socket=38;5;45:*.sparseimage=38;5;124:*.spl=38;5;7:*.spv=38;5;217:*.sql=38;5;222:*.sqlite=38;5;60:*.srt=38;5;117:*.ssa=38;5;117:*.st=38;5;213:*.stackdump=38;5;241:*.state=38;5;248:*.stderr=38;5;160;1:st=38;5;86;48;5;234:tw=48;5;235;38;5;139;3:*.stl=38;5;216:*.storyboard=38;5;196:*.strings=1:*.sty=38;5;7:*.sub=38;5;117:*.sublime-build=1:*.sublime-commands=1:*.sublime-keymap=1:*.sublime-project=1:*.sublime-settings=1:*.sublime-snippet=1:*.sublime-workspace=1:*.sug=38;5;7:*.sup=38;5;117:*.svelte=38;5;135;1:*.svg=38;5;99:*.swap=38;5;45:*.swift=38;5;219:*.swo=38;5;244:*.swp=38;5;244:*.sx=38;5;81:*.sz=38;5;40:*.t=38;5;114:*.tar=38;5;40:*.target=38;5;45:*.tbz=38;5;40:*.tcc=38;5;110:*.tcl=38;5;64;1:*.tdy=38;5;7:*.tex=38;5;184:*.textile=38;5;184:*.tf=38;5;168:*.tfm=38;5;7:*.tfnt=38;5;7:*.tfstate=38;5;168:*.tfvars=38;5;168:*.tg=38;5;7:*.tgz=38;5;40:*.theme=38;5;116:*.tif=38;5;97:*.tiff=38;5;97:*.TIFF=38;5;97:*.timer=38;5;45:*.tmp=38;5;244:*.tmTheme=1:*.toast=38;5;124:*.toml=38;5;178:*.torrent=38;5;116:*.ts=38;5;074;1:*.tsv=38;5;78:*.tsx=38;5;074;1:*.ttf=38;5;66:*.twig=38;5;81:*.txt=38;5;253:*.typelib=38;5;60:*.un~=38;5;241:*.urlview=38;5;116:*.user-ca-bundle=1:*.v=38;5;81:*.vala=38;5;81:*.vapi=38;5;81:*.vb=38;5;81:*.vba=38;5;81:*.vbs=38;5;81:*.vcard=38;5;7:*.vcd=38;5;124:*.vcf=38;5;7:*.vdf=38;5;215:*.vdi=38;5;124:*VERSION=38;5;220;1:*.vert=38;5;136:*.vfd=38;5;124:*.vhd=38;5;124:*.vhdx=38;5;124:*.vim=38;5;172:*.viminfo=1:*.vmdk=38;5;124:*.vob=38;5;115;1:*.VOB=38;5;115;1:*.vpk=38;5;215:*.vtt=38;5;117:*.vue=38;5;135;1:*.war=38;5;215:*.warc=38;5;40:*.WARC=38;5;40:*.wav=38;5;136;1:*.webloc=38;5;116:*.webm=38;5;115:*.webp=38;5;97:*.wgsl=38;5;97:*.wma=38;5;137;1:*.wmv=38;5;114:*.woff2=38;5;66:*.woff=38;5;66:*.wrl=38;5;216:*.wv=38;5;136;1:*.wvc=38;5;136;1:*.xcconfig=1:*.xcf=38;5;7:*.xcsettings=1:*.xcuserstate=1:*.xcworkspacedata=1:*.xib=38;5;208:*.xla=38;5;76:*.xln=38;5;7:*.xls=38;5;112:*.xlsx=38;5;112:*.xlsxm=38;5;112;4:*.xltm=38;5;73;4:*.xltx=38;5;73:*.xml=38;5;178:*.xpi=38;5;215:*.xpm=38;5;97:*.xsd=38;5;178:*.xsh=38;5;41:*.xz=38;5;40:*.yaml=38;5;178:*.yml=38;5;178:*.z[0-9]{0,2}=38;5;239:*.z=38;5;40:*.zcompdump=38;5;241:*.zig=38;5;81:*.zip=38;5;40:*.zipx=38;5;40:*.zlogin=1:*.zlogout=1:*.zoo=38;5;40:*.zpaq=38;5;40:*.zprofile=1:*.zsh=38;5;172:*.zshenv=1:*.zst=38;5;40:*.zstd=38;5;40:*.zwc=38;5;241:*.zx[0-9]{0,2}=38;5;239:*.zz=38;5;40:';
export LS_COLORS
