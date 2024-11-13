
#alias nvim-lazy="NVIM_APPNAME=LazyVim nvim"
#alias nvim-kick="NVIM_APPNAME=kickstart nvim"
#alias nvim-chad="NVIM_APPNAME=NvChad nvim"
#alias nvim-astro="NVIM_APPNAME=AstroNvim nvim"

#  items=("default" "kickstart" "LazyVim" "NvChad" "AstroNvim")

function nvims() {
  items=("LazyVim" "Old config")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "LazyVim" ]]; then
    config=""
  elif [[ $config == "Old config" ]]; then
    config='nvim-old'
  fi
  NVIM_APPNAME=$config nvim $@
}

# If want to start by using alias.
alias lvim="NVIM_APPNAME=LazyVim nvim $@"
alias nvim-old="NVIM_APPNAME=nvim-old nvim $@"

# bindkey -s '^a' "nvims\n"
