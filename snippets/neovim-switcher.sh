
# Pick an installed Neovim configuration to run from list using fzf.
function nvims() {
  items=("Custom" "Lazyvim" "Default Lazyvim" "Minimal" "NvChad" "AstroNvim" "SpaceVim" "Old config" "No plugins" "MiniMax" )
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)

  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "Custom" ]]; then
    config="custom"
  elif [[ $config == "Lazyvim" ]]; then
    config="lazyvim"
  elif [[ $config == "Default Lazyvim" ]]; then
    config="lazyvim-default"
  elif [[ $config == "MiniMax" ]]; then
    config='minimax'
  elif [[ $config == "NvChad" ]]; then
    config='nvchad'
  elif [[ $config == "AstroNvim" ]]; then
    config='astroNvim'
  elif [[ $config == "SpaceVim" ]]; then
    config='SpaceVim'
  elif [[ $config == "Minimal" ]]; then
    config='minimal'
  elif [[ $config == "No plugins" ]]; then
    config='no_plugins'
  elif [[ $config == "Old config" ]]; then
    config='old'
  fi
  config="nvim/$config"
  NVIM_APPNAME="$config" nvim "$@"
}

# If want to start by using alias instead.
lazyvim() { NVIM_APPNAME="nvim/lazyvim" nvim "$@"; }
lazyvim-default() { NVIM_APPNAME="nvim/lazyvim-default" nvim "$@"; }
nvim-old() { NVIM_APPNAME="nvim/old" nvim "$@"; }
nvchad() { NVIM_APPNAME="nvim/nvchad" nvim "$@"; }
astro() { NVIM_APPNAME="nvim/astroNvim" nvim "$@"; }
spacevim() { NVIM_APPNAME="vim/spaceVim" nvim "$@"; }
nvim-noplugins() { NVIM_APPNAME="nvim/no_plugins" nvim "$@"; }
mini() { NVIM_APPNAME="nvim/minimax" nvim "$@"; }
nvim-custom() { NVIM_APPNAME="nvim/custom" nvim "$@"; }
nvim-minimal() { NVIM_APPNAME="nvim/minimal" nvim "$@"; }
