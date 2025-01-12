
# Miscellaneous snippet definitions

# LS COLORS

# ! Needs to be before completion settings.
# Colors for ls/eza/exa. Doesn't work if put in .zprofile.
# Patched from LS_COLORS: A collection of LS_COLORS definitions.
# https://github.com/trapd00r/LS_COLORS/tree/master
ls_colors="$HOME/.config/shells/ls_colors.sh"

if [[ -e $ls_colors ]]; then
  zinit ice id-as"LS_COLORS"
  zinit snippet "$ls_colors"
fi
# zinit ice atinit'dircolors -b ls_colors > ls_colors.zsh' pick"ls_colors.zsh"


# General Colorizer.

file="$HOME/.config/shells/grc.sh"

if [[ (( $+commands[grc] )) && -e $file ]]; then
  zinit ice wait"1" id-as"grc.sh" lucid
  zinit snippet $file
fi

# FZF
(( $+commands[fzf] )) && source <(fzf --zsh)


