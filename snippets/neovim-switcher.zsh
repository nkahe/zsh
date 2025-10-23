
# Pick an installed Neovim configuration to run from list using fzf.
function nvims() {
  items=("LazyVim" "Minimal" "NvChad" "AstroNvim" "SpaceVim" "Old config" "No plugins" "MiniMax" )
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "LazyVim" ]]; then
    config=""
  elif [[ $config == "Old config" ]]; then
    config='nvim-old'
  elif [[ $config == "NvChad" ]]; then
    config='nvchad'
  elif [[ $config == "AstroNvim" ]]; then
    config='astroNvim'
  elif [[ $config == "SpaceVim" ]]; then
    config='SpaceVim'
  elif [[ $config == "No plugins" ]]; then
    config='nvim-no_plugins'
  elif [[ $config == "MiniMax" ]]; then
    config='nvim-minimax'
  fi
  NVIM_APPNAME=$config nvim $@
}

# If want to start by using alias instead.
alias lazyvim="nvim $@"
alias nvim-old="NVIM_APPNAME=nvim-old nvim $@"
alias nvchad="NVIM_APPNAME=nvchad nvim $@"
alias astro="NVIM_APPNAME=astroNvim nvim $@"
alias spacevim="NVIM_APPNAME=SpaceVim nvim $@"
alias nvim-noplugins="NVIM_APPNAME=nvim-no_plugins nvim $@"
alias minimax="NVIM_APPNAME=nvim-minimax nvim $@"
