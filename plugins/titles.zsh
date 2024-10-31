# Forked from Prezto: terminal.zsh
# Sets terminal window and tab titles.
#
# Original authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   Olaf Conradi <olaf@conradi.org>
#

# Original https://github.com/sorin-ionescu/prezto/blob/master/modules/terminal/init.zsh

# Return if requirements are not found.
if [[ "$TERM" == (dumb|linux|*bsd*|eterm*) ]]; then
  return 1
fi

# Sets the terminal _window_ title.
function set-window-title {
  # Yakuake window titles are controlled by the application.
  # In Konsole window title is same as tab title.
  case "$TERMINAL" in
    konsole|yakuake) return ;;
  esac
  local title_format{,ted}
  zstyle -s ':prezto:module:terminal:window-title' format 'title_format' || title_format="%s"
  zformat -f title_formatted "$title_format" "s:$argv"
  printf '\e]2;%s\a' "${(V%)title_formatted}"
}

TERMINAL=$(ps -o comm= "$PPID")

if [[ $TERMINAL == "yakuake" ]]; then
  session_id=$(qdbus org.kde.yakuake /yakuake/sessions org.kde.yakuake.activeSessionId)
fi

#echo "Terminal: ${TERMINAL}"
#echo "session id: $session_id"

# FIXME: joskus "micro " + pitkä litannia palautti "micro micro".

# Sets the terminal tab title.
function set-tab-title {
  local title_format{,ted}
  zstyle -s ':prezto:module:terminal:tab-title' format 'title_format' || title_format="%s"
  zformat -f title_formatted "$title_format" "s:$argv"

  case "$TERMINAL" in
    yakuake)
      # TODO: way to get this to work with root?
      # Getting needed session id doesn't work for root user.
      [[ $UID == 0 || -z "$session_id" ]] && return
      qdbus >/dev/null org.kde.yakuake /yakuake/tabs setTabTitle $session_id \
        "${(V%)title_formatted}"
    ;;
    konsole)
      set-konsole-tab-title "${(V%)title_formatted}"
    ;;
    terminator|terminology)
      printf '\033]0;%s\a' "${(V%)title_formatted}"
    ;;
    *)
      printf '\e]1;%s\a' "${(V%)title_formatted}"
    ;;
    esac
 }


 # TODO: type on varmaan kutsuttaessa aina 0, vaikka ei aina oikeasti olisi.

# Set tab title for Konsole. Konsole uses this also for window title.
# Function originally by Stefan Becker and Smar:
# https://stackoverflow.com/questions/19897787/change-konsole-tab-title-from-command-line-and-make-it-persistent
function set-konsole-tab-title {
  local _title="$1"
  # Default type to 0.
  local _type=${2:-0}
  [[ -z "${_title}" ]]               && return 1
  [[ -z "${KONSOLE_DBUS_SERVICE}" ]] && return 1
  [[ -z "${KONSOLE_DBUS_SESSION}" ]] && return 1
  qdbus >/dev/null "${KONSOLE_DBUS_SERVICE}" "${KONSOLE_DBUS_SESSION}" \
    setTabTitleFormat "${_type}" "${_title}"
}

# Sets the terminal multiplexer tab title.
 function set-multiplexer-title {
  local title_format{,ted}
  zstyle -s ':prezto:module:terminal:multiplexer-title' format 'title_format' || title_format="%s"
  zformat -f title_formatted "$title_format" "s:$argv"
  printf '\ek%s\e\\' "${(V%)title_formatted}"
}

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
    # Set the command name, or in the case of these commands, the next command.
    local cmd="${${2[(wr)^(*=*|sudo|su|ssh|mosh|rake|-*)]}:t}"

    # Find the first non-option argument that is not identical to `cmd`.
    local second_word=""
    for word in "${2[(w)2,-1]}"; do
      if [[ "$word" != -* && "$word" != "$cmd" ]]; then
        second_word="$word"
        break
      fi
    done

    # Append second_word to cmd only if it’s non-empty and distinct from cmd.
    [[ -n "$second_word" ]] && cmd="$cmd $second_word"

    # Truncate if longer than 15 characters.
    local truncated_cmd="${cmd/(#m)?(#c15,)/${MATCH[1,12]}...}"
    unset MATCH

    # Use set-tab-title to update the tab title.
    set-tab-title "$truncated_cmd"

    # Set the window title without truncation.
    set-window-title "$cmd"
  fi
}

# Sets the tab and window titles with a given path.
function _terminal-set-titles-with-path {
  emulate -L zsh
  setopt EXTENDED_GLOB
  local absolute_path="${${1:a}:-$PWD}"
  local abbreviated_path="${absolute_path/#$HOME/~}"

  # Terminator uses wide tabs so in that case make path 20 characters wide.
  [[ $TERMINAL == terminator ]] && local width="-20" || local width="-12"

  local truncated_path="${abbreviated_path/(#m)?(#c15,)/...${MATCH[$width,-1]}}"
  unset MATCH

  if [[ "$TERM" == screen* ]]; then
    set-multiplexer-title "$truncated_path"
  fi

  #echo "truncated_path: $truncated_path"
  #echo "abbreviated_path: $abbreviated_path"
  set-tab-title "$truncated_path"
  set-window-title "$abbreviated_path"
}

# Do not override precmd/preexec; append to the hook array.
autoload -Uz add-zsh-hook

# Set up the Apple Terminal.
if [[ "$TERM_PROGRAM" == 'Apple_Terminal' ]] \
  && ( ! [[ -n "$STY" || -n "$TMUX" || -n "$DVTM" ]] )
then
  # Sets the Terminal.app current working directory before the prompt is
  # displayed.
  function _terminal-set-terminal-app-proxy-icon {
    printf '\e]7;%s\a' "file://${HOST}${PWD// /%20}"
  }
  add-zsh-hook precmd _terminal-set-terminal-app-proxy-icon

  # Unsets the Terminal.app current working directory when a terminal
  # multiplexer or remote connection is started since it can no longer be
  # updated, and it becomes confusing when the directory displayed in the title
  # bar is no longer synchronized with real current working directory.
  function _terminal-unset-terminal-app-proxy-icon {
    if [[ "${2[(w)1]:t}" == (screen|tmux|dvtm|ssh|mosh) ]]; then
      print '\e]7;\a'
    fi
  }
  add-zsh-hook preexec _terminal-unset-terminal-app-proxy-icon

  # Do not set the tab and window titles in Terminal.app since it sets the tab
  # title to the currently running process by default and the current working
  # directory is set separately.
  return
fi

# Set up non-Apple terminals.
if zstyle -t ':prezto:module:terminal' auto-title 'always' \
  || (zstyle -t ':prezto:module:terminal' auto-title \
    && ( ! [[ -n "$STY" || -n "$TMUX" ]] ))
then
  # Sets titles before the prompt is displayed.
  add-zsh-hook precmd _terminal-set-titles-with-path

  # Sets titles before command execution.
  add-zsh-hook preexec _terminal-set-titles-with-command
fi
