
# nvbn/thefuck: Magnificent app which corrects your previous console command.
# https://github.com/nvbn/thefuck

# Lazyloading thefuck
if (( $+commands[thefuck] )); then
  function fuck() {
    if [[ thefuck_initialized!="true" ]]; then
      eval "$(thefuck --alias)"
      thefuck_initialized="true"
    fi
    fuck "$@"
  }
fi

