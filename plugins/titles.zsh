# Prezto: terminal.zsh
# Sets terminal window and tab titles.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   Olaf Conradi <olaf@conradi.org>
#
# Changes from original: (22-3-17)
# Added line 32 dbus command so it works with Yakuake.
# Commented window title changes.
# Removed support for Apple terminals.

# Return if requirements are not found.
if [[ "$TERM" == (dumb|linux|*bsd*|eterm*) ]]; then
  return 1
fi

# Sets the terminal window title.
# function set-window-title {
#  local title_format{,ted}
#  zstyle -s ':prezto:module:terminal:window-title' format 'title_format' || title_format="%s"
#  zformat -f title_formatted "$title_format" "s:$argv"
#  printf '\e]2;%s\a' "${(V%)title_formatted}"
#}

# FIXME: miten asettaa Yakuakella/konsolella tab title, jos 'qdbus'
# paketista libqt4 ei ole asennettu. qt5:lla ei välttämättä ole.

# FIXME: ei tunnista terminaaleja oikein, jos on useita käynnissä.

running() {
  if pgrep "$1" &> /dev/null; then
    return 1
  else
    return 0
  fi
}

# Which terminal we are running.
if running yakuake; then
  export TERMINAL=yakuake
  if [[ $UID != 0 ]]; then   # Doesn't work for root.
    # Find out the right Yakuake session id.
    if command -v qdbus &>/dev/null; then
      session_id="$(qdbus org.kde.yakuake /yakuake/sessions sessionIdList | tr , "\n" | sort -g | tail -1 | tr -d '\n')"
    fi
  fi
elif running terminator; then
  # http://terminator-gtk3.readthedocs.io/en/latest/index.html
  export TERMINAL=terminator
elif running konsole; then
  export TERMINAL=konsole
elif running terminology; then
  # http://terminator-gtk3.readthedocs.io/en/latest/index.html
  export TERMINAL=terminology
fi

# Sets the terminal tab title.
function set-tab-title {
  local title_format{,ted}
  zstyle -s ':prezto:module:terminal:tab-title' format 'title_format' || title_format="%s"
  zformat -f title_formatted "$title_format" "s:$argv"

  # ADDED. Yakuake -terminal's tab titles are changed by dbus. Terminator command fixed too.

  case "$TERMINAL" in
    yakuake)
      # Doesn't work if we are root or we couldn't figure out session id.
      if [[ $UID == 0 ]] || [[ "$session_id" = "" ]]; then
        return 1
      fi
      qdbus org.kde.yakuake /yakuake/tabs setTabTitle $session_id "${(V%)title_formatted}"
    ;;
    terminator|terminology)
      printf '\033]0;%s\a' "${(V%)title_formatted}" ;;
    *)
      printf '\e]1;%s\a' "${(V%)title_formatted}" ;;
    esac
 }

# Sets the terminal multiplexer tab title.
 function set-multiplexer-title {
  local title_format{,ted}
  zstyle -s ':prezto:module:terminal:multiplexer-title' format 'title_format' || title_format="%s"
  zformat -f title_formatted "$title_format" "s:$argv"
  printf '\ek%s\e\\' "${(V%)title_formatted}"
}

# Sets the tab and window titles with a given command.
function _terminal-set-titles-with-command {
  emulate -L zsh
  setopt EXTENDED_GLOB

  # Get the command name that is under job control.
  if [[ "${2[(w)1]}" == (fg|%*)(\;|) ]]; then
    # Get the job name, and, if missing, set it to the default %+.
    local job_name="${${2[(wr)%*(\;|)]}:-%+}"

    # Make a local copy for use in the subshell.
    local -A jobtexts_from_parent_shell
    jobtexts_from_parent_shell=(${(kv)jobtexts})

    jobs "$job_name" 2> /dev/null > >(
      read index discarded
      # The index is already surrounded by brackets: [1].
      _terminal-set-titles-with-command "${(e):-\$jobtexts_from_parent_shell$index}"
    )
  else
    # Set the command name, or in the case of sudo or ssh, the next command.
    local cmd="${${2[(wr)^(*=*|sudo|ssh|-*)]}:t}"
    local truncated_cmd="${cmd/(#m)?(#c15,)/${MATCH[1,12]}...}"
    unset MATCH

    if [[ "$TERM" == screen* ]]; then
       set-multiplexer-title "$truncated_cmd"
    fi

   # ADDED. Change title to prettier in some cases.
   case "$truncated_cmd" in
     irc) truncated_cmd="Irssi" ;;
     su)  truncated_cmd="root" ;;
   esac

   set-tab-title "$truncated_cmd"
   # Uncomment if you want also _window_ title.
   # set-window-title "$cmd"
  fi
}

# Sets the tab and window titles with a given path.
function _terminal-set-titles-with-path {
  emulate -L zsh
  setopt EXTENDED_GLOB

  local absolute_path="${${1:a}:-$PWD}"
  local abbreviated_path="${absolute_path/#$HOME/~}"
  if [[ $TERMINAL == terminator ]]; then
    # Terminator uses wide tabs so in that case make path 20 characters wide.
    local width="-20"
  else
    local width="-12"
  fi
  local truncated_path="${abbreviated_path/(#m)?(#c15,)/...${MATCH[$width,-1]}}"
  unset MATCH

  if [[ "$TERM" == screen* ]]; then
    set-multiplexer-title "$truncated_path"
  fi
  set-tab-title "$truncated_path"
  # set-window-title "$abbreviated_path"
}

# Do not override precmd/preexec; append to the hook array.
autoload -Uz add-zsh-hook

# Set up terminals.
if zstyle -t ':prezto:module:terminal' auto-title 'always' \
  || (zstyle -t ':prezto:module:terminal' auto-title \
    && ( ! [[ -n "$STY" || -n "$TMUX" ]] ))
then
  # Sets titles before the prompt is displayed.
  add-zsh-hook precmd _terminal-set-titles-with-path

  # Sets titles before command execution.
  add-zsh-hook preexec _terminal-set-titles-with-command
fi
