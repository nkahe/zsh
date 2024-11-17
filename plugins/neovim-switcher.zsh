
#alias nvim-lazy="NVIM_APPNAME=LazyVim nvim"
#alias nvim-kick="NVIM_APPNAME=kickstart nvim"
#alias nvim-chad="NVIM_APPNAME=NvChad nvim"
#alias nvim-astro="NVIM_APPNAME=AstroNvim nvim"

#  items=("default" "kickstart" "LazyVim" "NvChad" "AstroNvim")

function nvims() {
  items=("LazyVim" "NvChad" "AstroNvim" "Old config" )
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
  fi
  NVIM_APPNAME=$config nvim $@
}

# If want to start by using alias.
alias lvim="nvim $@"
alias nvim-old="NVIM_APPNAME=nvim-old nvim $@"
alias nvchad="NVIM_APPNAME=nvchad nvim $@"
alias astro="NVIM_APPNAME=astroNvim nvim $@"

# bindkey -s '^a' "nvims\n"
