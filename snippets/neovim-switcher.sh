# Pick an installed Neovim configuration to run from list using fzf.
#
function nvims() {
  if ! command -v fzf >/dev/null 2>&1; then
    echo "nvims: fzf is not installed" >&2
    return 1
  fi
  if ! command -v nvim >/dev/null 2>&1; then
    echo "nvims: nvim is not installed" >&2
    return 1
  fi

  items=("Custom" "Lazyvim" "Default Lazyvim" "Kitty scrollback" "Minimal" "NvChad" "AstroNvim" "SpaceVim" "Old config" "No plugins" "MiniMax" "Testing")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)

  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  fi

  case "$config" in
    Custom)  config="custom"  ;;
    Lazyvim) config="lazyvim" ;;
    MiniMax) config='minimax' ;;
    NvChad)  config='nvchad'  ;;
    Minimal) config='minimal' ;;
    Testing) config='testing' ;;
    SpaceVim)  config='SpaceVim'  ;;
    AstroNvim) config='astroNvim' ;;
    "Old config") config='old' ;;
    "No plugins") config='no_plugins'  ;;
    "Kitty scrollback") config="kitty" ;;
    "Default Lazyvim") config="lazyvim-default" ;;
  esac

  config="nvim/$config"
  config_dir="$HOME/.config/$config"
  if [[ ! -d $config_dir ]]; then
    echo "nvims: config directory not found: $config_dir" >&2
    return 1
  fi

  NVIM_APPNAME="$config" nvim "$@"
}

# If want to start by using alias instead.
mini() { NVIM_APPNAME="nvim/minimax" nvim "$@"; }
minimax() { NVIM_APPNAME="nvim/minimax" nvim "$@"; }
lazyvim() { NVIM_APPNAME="nvim/lazyvim" nvim "$@"; }
nvchad() { NVIM_APPNAME="nvim/nvchad" nvim "$@"; }
astro() { NVIM_APPNAME="nvim/astroNvim" nvim "$@"; }
spacevim() { NVIM_APPNAME="vim/spaceVim" nvim "$@"; }
nvim-noplugins() { NVIM_APPNAME="nvim/no_plugins" nvim "$@"; }
nvim-custom() { NVIM_APPNAME="nvim/custom" nvim "$@"; }
nvim-minimal() { NVIM_APPNAME="nvim/minimal" nvim "$@"; }
nvim-testing() { NVIM_APPNAME="nvim/testing" nvim "$@"; }
nvim-kitty() { NVIM_APPNAME="nvim/kitty" nvim "$@"; }
lazyvim-default() { NVIM_APPNAME="nvim/lazyvim-default" nvim "$@"; }
