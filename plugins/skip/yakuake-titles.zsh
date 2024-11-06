# Forked from Prezto: terminal.zsh
# Sets terminal window and tab titles.
#
# Containing only terminal detection for konsole and yakuake.
# For making conversions to different languages using AI.
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
      # Getting needed session id doesn't work for root user.
      [[ $UID == 0 || -z "$session_id" ]] && return
      qdbus >/dev/null org.kde.yakuake /yakuake/tabs setTabTitle $session_id \
        "${(V%)title_formatted}"
    ;;
    konsole)
      set-konsole-tab-title "${(V%)title_formatted}"
    ;;
    esac
 }

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

function _terminal-set-titles-with-command {
  emulate -L zsh
  setopt EXTENDED_GLOB

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

  # Truncate if longer than 20 characters.
  local truncated_cmd="${cmd/(#m)?(#c20,)/${MATCH[1,17]}...}"

  unset MATCH

  set-tab-title "$truncated_cmd"
}

# Sets the tab and window titles with a given path.
function _terminal-set-titles-with-path {
  emulate -L zsh
  setopt EXTENDED_GLOB
  local absolute_path="${${1:a}:-$PWD}"
  local abbreviated_path="${absolute_path/#$HOME/~}"
  local width="-12"
  local truncated_path="${abbreviated_path/(#m)?(#c15,)/...${MATCH[$width,-1]}}"
  unset MATCH
  set-tab-title "$truncated_path"
}

# Do not override precmd/preexec; append to the hook array.
autoload -Uz add-zsh-hook

# Set up
if zstyle -t ':prezto:module:terminal' auto-title 'always' \
  || (zstyle -t ':prezto:module:terminal' auto-title \
    && ( ! [[ -n "$STY" || -n "$TMUX" ]] ))
then
  # Sets titles before the prompt is displayed.
  add-zsh-hook precmd _terminal-set-titles-with-path

  # Sets titles before command execution.
  add-zsh-hook preexec _terminal-set-titles-with-command
fi
