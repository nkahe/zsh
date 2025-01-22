# Miscellaneous snippet definitions

# Patched from LS_COLORS: A collection of LS_COLORS definitions.
# https://github.com/trapd00r/LS_COLORS/tree/master
# NOTE: Needs to be before completion settings.
# Can't be in (z)profile since settings in /etc will overwrite them for
# interactive shells for many systems.
ls_colors="$HOME/.config/shells/ls_colors.sh"
if [[ -e $ls_colors ]]; then
  source $ls_colors
  # zinit ice id-as"LS_COLORS"
  # zinit snippet "$ls_colors"
fi
# zinit ice atinit'dircolors -b ls_colors > ls_colors.zsh' pick"ls_colors.zsh"

# garabik/grc: generic colouriser
# https://github.com/garabik/grc
file="$HOME/.config/shells/grc.sh"
if [[ (( $+commands[grc] )) && -e $file ]]; then
  zinit ice wait"1" id-as"grc.sh" lucid
  zinit snippet $file
fi

# fuzzy-finder/fzf: Fast Fuzzy Finder for Command-Line Search
# https://github.com/fuzzy-finder/fzf
(( $+commands[fzf] )) && source <(fzf --zsh)

