# Show greet message once per day.

# Finnish anniversaries
# Fortune -message

# Only for interactive shells.
case $- in
  *i*) ;;
  *) return 0 2>/dev/null || exit 0 ;;
esac

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/zsh"
state_file="$state_dir/start-message-date"
today="$(command date +%F)" || return

if [[ -r $state_file && "$(command cat -- "$state_file" 2>/dev/null)" == "$today" ]]; then
  return
fi

. $ZDOTDIR/lib/anniversaries.sh
anniversaries "$today"

if command -v fortune >/dev/null 2>&1; then
  fortune
fi

mkdir -p -- "$state_dir" || return
printf '%s\n' "$today" > "$state_file"
