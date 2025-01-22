# My Zsh setup

This is my maximalistic [Z shell aka Zsh](https://zsh.sourceforge.io/) setup. It uses flexible and fast [Zinit plugin manager](https://github.com/zdharma-continuum/zinit). Some modules from [Prezto configuration framework](https://github.com/sorin-ionescu/prezto) are used and some are forked from them (files marked with asterisk in section Contents).

Why I use this instead of Prezto you might ask. With incorporating Zinit it's easier and faster to handle any external plugins. Zinit allows deferring plugin loading (aka Turbo mode) which makes startup faster and has lot other features like time profiling.

## Features

- Reasonable settings.
- Many plugins and snippets with deferred loading using Zinit.
- Many aliases and user functions.
- Custom keybindings

### Plugins

- Advanced and fast Starship -prompt
- Fast syntax highlighting
- Autosuggestions
- more

## Contents

Files and their function. They should be in $HOME/.config/zsh/.

- .zshenv - In user's home directory should be symlink to this file or copy of it. It tells Zsh where rest of the files are.
- .zprofile - Mainly Zsh -specific environment variables.
- .zshrc - First file that is processed during init and main configuration file of which rest of configurations are sourced.
- settings.zsh - Setting definitions which overwrite or add settings from Prezto modules.
- completion.zsh - Completion settings *
- aliases.sh - Common aliases that are compatible with Bash and can be sourced from Bash -settings.
- zsh-aliases.zsh - Zsh -specific aliases and functions.
- bindings.zsh - Keybindings *

All zsh-files directly under these directories are sourced from .zshrc during init.
- plugins/ - Directory containing plugin specs for Zinit. Files can contain many definitions.
- snippets/ - Directory containing different snippets. Some are Zinit specs for external snippets, some contain local snippet.
  - titles.zsh *
  - prezto.zsh - Specs for used Prezto modules.
- completions/ - Additional locally added completions.

`*` [!NOTE]  These are derived from Prezto modules. Changes can be seen in next section.

## Forked Prezto modules

For license see LICENSE -file. Settings are changed directly in the file instead of .zpreztorc like in Prezto.

### bindings.zsh

- Forked from Prezto editor -module.

Changes, added:
- Command to list bindings.
- Bindings:
- Toggle Vi / Emacs command mode.
- cd to previous / next directory, ls
# Support for some more common keys and shortcuts.

Removed:
- Functions for prompts since prompt is defined as plugin instead in plugins/prompt.zsh
- No definitions for plugins since deferred loading is used.
- Some bindings I don't use.

### titles.zsh

- Terminal module in Prezto.

Changes:
- Added support for Yakuake and Konsole -terminals which set titles differently using qdbus.
  - Spams messages to journalctl but works.
- Fix: drop first word of title if it's sudo, su, ssh, mosh or rake.
- Allow longer titles for Terminator -terminal which has wide tabs.

### completion.zsh

Changes:
- No LS_COLORS definition since I use fork of  [LS_COLORS: A collection of LS_COLORS definitions; needs your contribution!](https://github.com/trapd00r/LS_COLORS) instead.
- No compinit loading since it's done using Zinit when initializing syntax highlighting -plugin.
- Mutt's path ~/.mutt -> ~/.config/mutt
- Use $ZSH_CACHE_DIR for caching.
- Completion settings for more text editors, killall, Taskwarrior, Docker, Angular cli.
- When new programs is installed, auto update autocomplete without reloading shell.
