Zplug: zshrc

# zplug - a next-generation plugin manager. https://github.com/zplug/zplug
# source ~/.zplug/init.zsh

    # Manage zplug itself like other packages.
    # zplug 'zplug/zplug', hook-build:'zplug --self-manage'
    # zplug 'zplug/zplug', hook-build:'zplug --self-manage'


   # zplug "learnbyexample/command_help", use:ch, as:command, lazy:true

    # zplug "zsh-users/zsh-syntax-highlighting", defer:2

    # zplug "rupa/z", use:"z.sh", as:command

    # zplug "zsh-users/zsh-autosuggestions"

    # zplug "andrewferrier/fzf-z" #, lazy:true

    # zplug "MichaelAquilina/zsh-you-should-use"

    # zplug "zsh-users/zsh-history-substring-search"

    # zplug "$ZDOTDIR", from:local, use:zsh-aliases.zsh
    # zplug "$ZDOTDIR/themes", from:local, use:oma_teema.zsh-theme, as:theme, defer:3

    # $DOTFILES/ls_colors
    # zplug "$DOTFILES", from:local, use:ls_colors


    # Install plugins if there are plugins that have not been installed
    # if ! zplug check --verbose; then
    #   printf "Install? [y/N]: "
    #   if read -q; then
    #       echo; zplug install
    #   fi
    # fi
