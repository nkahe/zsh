# My Zsh configuration

This is my [Z shell aka Zsh](httpszsh.sourceforge.io/) configuration. It uses flexible and fast [antidote](https://antidote.sh/) plugin manager. Some modules from [Prezto configuration framework](https://github.com/sorin-ionescu/prezto) are used and [some are forked from them](#forked-prezto-modules). Aimed for Linux but this should work in Mac too although isn't actively tested.

## Features

- Full featured, yet fast. Load time is about 100 ms.
- Good settings mainly from Prezto.
- Many aliases, user functions and keybindings.
- Many plugins and snippets and their settings loaded with deferred loading for faster startup.

titles.zsh: My custom plugin / snippet forked originally from Prezto module.
It Updates terminal's window and titles dynamically based on terminal,
current working directory, last command and background jobs.

### Plugins configurations

- [zsh-patina:  fast Zsh plugin performing syntax highlighting](https://github.com/michel-kraemer/zsh-patina)
- zsh-users/zsh-autosuggestions
- [zsh-history-substring-search: 🐠 ZSH port of Fish history search ](https://github.com/zsh-users/zsh-history-substring-search)
- [zsh-completions: Additional completion definitions for Zsh.](https://github.com/clarketm/zsh-completions)
- [zsh-vi-mode: 💻 A better and friendly vi(vim) mode plugin for ZSH.](https://github.com/jeffreytse/zsh-vi-mode)
- [command_help: Extract help text from builtin commands and man pages](https://github.com/learnbyexample/command_help)
- and more

## Requirements

- zsh, git, internet connection for downloading.
Recommended:
- [Nerd Fonts](https://www.nerdfonts.com/) - fonts with glyphs for Starship prompt and eza, etc.
- [Starship -prompt](https://starship.rs)
- [eza: A modern alternative to ls](https://github.com/eza-community/eza)
- fzf - fuzzy finder
- For Wayland desktop: wl-copy for clipboard operations.

Contains configs for example:
- [zoxide: A smarter cd command. Supports all major shells.](https://github.com/ajeetdsouza/zoxide)
- [grc - generic colouriser](https://github.com/garabik/grc)
- [ccze - a fast log colorizer](https://github.com/cornet/ccze)
[cheat - allows you to create and view interactive cheatsheets on the command-line](https://github.com/cheat/cheat)
- [navi: An interactive cheatsheet tool for the command-line](https://github.com/denisidoro/navi)
- [tldr-pages/tldr-python-client: Python command-line client for tldr pages 📚](https://github.com/tldr-pages/tldr-python-client)
- [translate-shell: Command-line translator using Google Translate, Bing Translator, Yandex.Translate, etc.](https://github.com/soimort/translate-shell)
- [termdown: Countdown timer and stopwatch in your terminal](https://github.com/trehn/termdown)

## Files

- .zshenv - Tells Zsh where rest of the files are which is ~/.config/zsh/ by default.
- zprofile - Environment variables that can be used in Bash too.
- zshrc - Main configuration file of which rest of configurations are sourced.
- aliases.sh - Aliases and functions that can be used in Bash too.
- bindings.zsh - Key bindings for Zsh line editor. *
- completion.zsh - Completion settings. *
- settings.zsh - General Zsh options and some other settings.
- zsh-aliases.zsh - Zsh -specific aliases and alias-like functions.
- zsh_plugins.txt - Zsh plugins to be loaded by Antidote.
- zsh_plugins.zsh - Output file of Antidote.

All .zsh-files directly under these directories are sourced from .zshrc during init.
- archive/ - Scripts not in use anymore.
- completions/ - Additional locally added completions.
- lib/ - Files that are individually sourced.
- snippets/ - All .zsh and .sh files in this dir are loaded with deferring of 1s.
  - titles.zsh - *
  - *.sh - Snippets that can be sourced from other shells too.
- later/ - Files in this dir are loaded with longest defer time.

> [!NOTE]
> `*` These are derived from Prezto modules. Changes can be seen in next section.

## Installation

You probably don't want to install whole configuration as it is but this is how it could be done:

1. Install requirements if not present.
2. Git clone this repo in ~/.config which makes sub-directory "zsh". Custom directory can also be used.
3. If ~/.zshenv already exists backup by renaming it. Make a symlink to home directory pointing to .zshenv or copy it:
```sh
ln -s ~/.config/zsh/.zshenv ~/.zshenv
```
 or:
```sh
cp ~/.config/zsh/.zshenv ~
```

1. If using different directory for the config, change it in .zshenv accordingly.
2. Start a new shell. If Antidote installation is not found, it is installed automatically
with Git and all defined external plugins and snippets are being pulled.

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

MIT. See [LICENSE -file](./LICENSE)
