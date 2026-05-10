# nvbn/thefuck: Magnificent app which corrects your previous console command.
# https://github.com/nvbn/thefuck

if ! command -v fuck &>/dev/null; then
  return
fi

# Lazyloading thefuck
function fuck() {
  if [[ thefuck_initialized!="true" ]]; then
    eval "$(thefuck --alias)"
    thefuck_initialized="true"
  fi
  fuck "$@"
}
