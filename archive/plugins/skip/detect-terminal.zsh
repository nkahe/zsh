
# Test script which tries to detect terminal even if using tmux.

# Function to get the terminal name from the parent process tree
get_terminal_name() {
  local pid="$1"
  while [[ "$pid" -ne 1 ]]; do
    parent_cmd=$(ps -o comm= -p "$pid")

    echo "parent_cmd $parent_cmd"

    # Check if the parent command is a known terminal emulator
    case "$parent_cmd" in
      gnome-terminal|konsole|xterm|terminator|urxvt|alacritty|kitty|yakuake|xfce4-terminal)
        echo "$parent_cmd"
        return
        ;;
    esac

    # Move to the parent process
    pid=$(ps -o ppid= -p "$pid")
  done

  # Return unknown if no terminal found
  echo "unknown"
}

# Initialize the terminal variable
TERMINAL=""

# If we're inside a tmux session, we need to check the parent process tree
if [[ -n "$TMUX" ]]; then

  # Get the PID of the current shell
  current_shell_pid="$PPID"

  echo "Get the PID of the current shell $current_shell_pid"

  echo "Get the terminal emulator from the parent process tree"
  # Get the terminal emulator from the parent process tree
  TERMINAL=$(get_terminal_name "$current_shell_pid")
else
  # Not inside tmux, get the terminal from the PPID
  TERMINAL=$(ps -o comm= "$PPID")
fi

# Default to 'unknown' if no terminal was found
TERMINAL="${TERMINAL:-unknown}"
echo "$TERMINAL"
