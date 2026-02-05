# Forked from Prezto "terminal" module. See "LICENSE" -file.
# https://github.com/sorin-ionescu/prezto/blob/master/modules/terminal/init.zsh

# Sets terminal window and tab titles.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   Olaf Conradi <olaf@conradi.org>
#
#   Henri K.

# NOTE: While setting tab title works in Yakuake, it gives message to journalctl:
# yakuake: Skipped method "setTabTitle" : Type not registered with QtDBus in parameter list: TabBar::InteractiveType

# Return if requirements are not found.
if [[ $TERM == (dumb|linux|*bsd*|eterm*) ]]; then
  return 1
fi

# Settings. In Prezto these are defined in .zpreztorc.

# Auto set the tab and window titles.
zstyle ':prezto:module:terminal' auto-title 'yes'

# Set the window title format.
# zstyle ':prezto:module:terminal:window-title' format '%n@%m: %s'

# Set the tab title format.
# zstyle ':prezto:module:terminal:tab-title' format '%m: %s'

# Set the terminal multiplexer title format.
# zstyle ':prezto:module:terminal:multiplexer-title' format '%s'

# Sets the terminal window title.
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
      # echo "session_id: $session_id title: ${(V%)title_formatted}"
      # Without redirection to /dev/null extra line change is printed.
      qdbus org.kde.yakuake /yakuake/tabs setTabTitle "$session_id" \
        "${(V%)title_formatted}" &>/dev/null
      # echo "qdbus org.kde.yakuake /yakuake/tabs setTabTitle \"$session_id\" \"${(V%)title_formatted}\""
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
    # Set the command name, or in the case of these commands, the next command.
    # local cmd="${${2[(wr)^(*=*|sudo|su|ssh|mosh|rake|-*)]}:t}"

    # Changed from Prezto: dropping first word of title in certain cases.

    # Assuming $2 contains the entire command line.
    # Split the command into an array
    local cmd_array=(${(z)2})

    # Check if the first word is one of the specified prefixes.
    if [[ "${cmd_array[1]}" == (sudo|su|ssh|mosh|rake) ]]; then
      # Remove the first word and keep the rest of the line.
      local cmd="${(j: :)${cmd_array[2,-1]}}"
    else
      # Otherwise, keep the whole command line.
      local cmd="${(j: :)${cmd_array[@]}}"
    fi

    # Truncate long titles if needed.
    local max_width=20
    local keep=17
      if (( ${#cmd} > max_width )); then
        truncated_cmd="${cmd[1,$keep]}..."
      else
        truncated_cmd="$cmd"
      fi

    if [[ $TERM == screen* ]]; then
      set-multiplexer-title "$truncated_cmd"
    fi
    set-tab-title "$truncated_cmd"
    set-window-title "$cmd"
  fi
}

# Sets the tab and window titles with a given path.
function _terminal-set-titles-with-path {
  emulate -L zsh
  setopt EXTENDED_GLOB

  local absolute_path="${${1:a}:-$PWD}"
  local abbreviated_path="${absolute_path/#$HOME/~}"

  # Truncate long titles if needed.
  local max_width=20
  local keep=17
  if (( ${#abbreviated_path} > max_width )); then
    truncated_path="...${abbreviated_path[-$keep,-1]}"
  else
    truncated_path="$abbreviated_path"
  fi

  if [[ $TERM == screen* ]]; then
    set-multiplexer-title "$truncated_path"
  fi
  set-tab-title "$truncated_path"
  set-window-title "$abbreviated_path"
}

# Do not override precmd/preexec; append to the hook array.
autoload -Uz add-zsh-hook

# Set up the Apple Terminal.
if [[ $TERM_PROGRAM == Apple_Terminal ]] \
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
