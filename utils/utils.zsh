# Utility functions

# Check if command exists.
function has() {
  if command -v "$@" &> /dev/null; then
    return 0
  else
    return 1
  fi
}
