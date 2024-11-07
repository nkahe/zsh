alias nvim-lazy="NVIM_APPNAME=LazyVim nvim"
#alias nvim-kick="NVIM_APPNAME=kickstart nvim"
#alias nvim-chad="NVIM_APPNAME=NvChad nvim"
#alias nvim-astro="NVIM_APPNAME=AstroNvim nvim"

#  items=("default" "kickstart" "LazyVim" "NvChad" "AstroNvim")

function nvims() {
  items=("default" "LazyVim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

alias lvim="NVIM_APPNAME=LazyVim nvim $@"

bindkey -s '^a' "nvims\n"
