# My Zsh configuration

This is my [Z shell aka Zsh](httpszsh.sourceforge.io/) configuration. It uses flexible and fast [antidote](https://antidote.sh/) plugin manager. Some modules from [Prezto configuration framework](https://github.com/sorin-ionescu/prezto) are used and [some are forked from them](#forked-prezto-modules). Aimed for Linux but this should work in Mac too although isn't actively tested.

## Features

- Full featured, yet fast.
- Good settings mainly from Prezto.
- Many aliases, user functions and keybindings.
- Many plugins and snippets and their settings loaded with deferred loading for faster startup.

titles.zsh: My custom plugin / snippet forked originally from Prezto module.
It Updates terminal's window and titles dynamically based on terminal,
current working directory, last command and background jobs.

### Plugins configurations

- [fast-syntax-highlighting: Feature-rich syntax highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting)
- [zsh-autosuggestions: Fish-like autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-history-substring-search: 🐠 ZSH port of Fish history search ](https://github.com/zsh-users/zsh-history-substring-search) with key bindings for emacs, vi -insert and normal modes.
- [zsh-completions: Additional completion definitions for Zsh.](https://github.com/clarketm/zsh-completions)
- [zsh-vi-mode: 💻 A better and friendly vi(vim) mode plugin for ZSH.](https://github.com/jeffreytse/zsh-vi-mode)
- [command_help: Extract help text from builtin commands and man pages](https://github.com/learnbyexample/command_help)
- more

## Requirements

- zsh, git

Recommended:
- [Nerd Fonts](https://www.nerdfonts.com/) - fonts with glyphs for Starship prompt and eza, etc.
- [Advanced and fast Starship -prompt](https://starship.rs)
- [eza: A modern alternative to ls](https://github.com/eza-community/eza) which is also recommended, fzf fuzzy finder, for Wayland desktop: wl-copy for clipboard operations.

Optional:
- [zoxide: A smarter cd command. Supports all major shells.](https://github.com/ajeetdsouza/zoxide)
- curl - for scripts getting information from web.
- [grc - generic colouriser](https://github.com/garabik/grc)
- [ccze - a fast log colorizer](https://github.com/cornet/ccze)
[cheat - allows you to create and view interactive cheatsheets on the command-line](https://github.com/cheat/cheat)
- [navi: An interactive cheatsheet tool for the command-line](https://github.com/denisidoro/navi)
- [tldr-pages/tldr-python-client: Python command-line client for tldr pages 📚](https://github.com/tldr-pages/tldr-python-client)
- [translate-shell: Command-line translator using Google Translate, Bing Translator, Yandex.Translate, etc.](https://github.com/soimort/translate-shell)
- [termdown: Countdown timer and stopwatch in your terminal](https://github.com/trehn/termdown)

## Files

- .zshenv - Tells Zsh where rest of the files are. In home directory should be a symlink with same the name to this file or a copy of it.
- zprofile - Environment variables that can be used in Bash too.
- zshrc - Main configuration file of which rest of configurations are sourced.
- aliases.sh - Aliases and functions that can be used in Bash too.
- bindings.zsh - Key bindings for Zsh line editor. *
- completion.zsh - Completion settings. *
- settings.zsh - General settings.
- zsh-aliases.zsh - Zsh -specific aliases and functions.
- zsh_plugins.txt - Used plugin specifications use by Antidote.

All .zsh-files directly under these directories are sourced from .zshrc during init.
- snippets/ - Different snippets.
  - titles.zsh - *
  - *.sh - Snippets that can be sourced from Bash too.
- completions/ - Additional locally added completions.
- later/ - Local files which use deferred loading for speed.

> [!NOTE]
> `*` These are derived from Prezto modules. Changes can be seen in next section.

## Installation

1. Install requirements.
2. Git clone this repo in ~/.config which makes sub-directory "zsh". Custom directory can also be used.
3. If ~/.zshenv already exists backup by renaming it. Make a hidden symlink to home directory pointing zshenv -file:
```
ln -s ~/.config/zsh/zshenv $HOME/.zshenv
```
 or copy it:
```
cp ~/.config/zsh/zshenv $HOME/.zshenv
```

1. If using different directory for the config, change it in .zshenv accordingly.
2. Start a new shell. If Zinit installation is not found, it is installed automatically
and all defined external plugins and snippets are being pulled.

### Forked Prezto modules

For license see [LICENSE -file](./LICENSE). Settings are changed directly in the file instead of .zpreztorc like in Prezto.

#### bindings.zsh

- Forked from Prezto editor -module.

Changes, added:
- Command to list bindings.
- Bindings:
- Toggle Vi / Emacs command mode.
- cd to previous / next directory, ls
- Support for some more common keys and shortcuts.

Removed:
- Functions for prompts since prompt is defined as plugin instead in plugins/prompt.zsh
- No definitions for plugins since deferred loading is used.
- Some bindings I don't use.

#### titles.zsh

- Forked from terminal module in Prezto.

Changes:
- Added support for Yakuake and Konsole -terminals which set titles differently using qdbus.
  - Spams messages to journalctl but works.
- Fix: drop first word of title if it's sudo, su, ssh, mosh or rake.
- Allow longer titles for Terminator -terminal which has wide tabs.

#### completion.zsh

- Forked from completion module in Prezto.

Changes:
- No LS_COLORS definition since I use fork of [LS_COLORS: A collection of LS_COLORS definitions; needs your contribution!](https://github.com/trapd00r/LS_COLORS) instead.
- No compinit loading since it's done using Zinit when initializing syntax highlighting -plugin.
- Mutt's path ~/.mutt -> ~/.config/mutt
- Use $ZSH_CACHE_DIR for caching.
- Completion settings for more text editors, killall, Taskwarrior, Docker, Angular cli.
- When new programs is installed, auto update autocomplete without reloading shell.

## License

See [LICENSE -file](./LICENSE)
