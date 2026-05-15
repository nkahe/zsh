# Change the current working directory when exiting Yazi.
if command -v yazi >/dev/null 2>&1; then
  function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      builtin cd -- "$cwd"
    fi
    command rm -f -- "$tmp"
  }
fi

# Make completion work in Zsh.
if [[ -n $ZSH_VERSION ]]; then
  compdef y=yazi
fi
