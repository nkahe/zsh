# My Zsh setup

This is my maximalistic [Z shell aka Zsh](https://zsh.sourceforge.io/) setup. It uses flexible and fast [Zinit plugin manager](https://github.com/zdharma-continuum/zinit). Some modules from [Prezto configuration framework](https://github.com/sorin-ionescu/prezto) are picked and some are forked from them (files marked with asterisk in section Contents). This setup also contains plugin specs, snippets, aliases, keybindings and different settings.

Why I use this instead of Prezto you might ask. I use Zinit to add and handle more plugins and snippets and delay their loading (aka Turbo mode) which makes startup faster. And have other Zinit features like time profiling.

## Features

- Reasonable settings.
- Lazy-loading many plugins and snippets with Zinit.
- Many aliases and keybindings.

### Plugins

- Fast syntax highlighting
- Autosuggestions
- Advanced and fast Starship -prompt
- more

## Contents

Files and their function. They should be in $HOME/.config/zsh/.

- .zshenv - In user's home directory should be symlink to this file or copy of it. It tells Zsh where rest of the files are.
- .zprofile - Mainly Zsh -specific environment variables.
- .zshrc - First file that is processed during init and main configuration file of which rest of configurations are sourced.
- settings.zsh - Setting definitions which overwrite or add settings from Prezto modules.
- completion.zsh - Completion settings. *
- aliases.sh - Common aliases that are compatible with Bash and can be sourced from Bash -settings.
- zsh-aliases.zsh - Zsh -specific aliases and functions.
- bindings.zsh - Keybindings *

All zsh-files directly under these directories are sourced from .zshrc during init.
- plugins/ - Directory containing plugin specs for Zinit. Files can contain many definitions.
- snippets/ - Directory containing different snippets. Some are Zinit specs for external snippets, some contain local snippet.
  - titles.zsh *
  - prezto.zsh - Specs for used Prezto modules.
- completions/ - Additional locally added completions.

`*` [!NOTE]  These are derived from Prezto modules. See LICENSE -file

## Forked Prezto modules

### titles.zsh, forked from terminal.zsh

Changes:
- Added support for Yakuake and Konsole -terminals which set titles differently.
  - Spams messages to journalctl but works.
- Fix: drop first word of title if it's sudo, su, ssh, mosh or rake.
- Allow longer titles for Terminator -terminal which has wide tabs.
- Settings are changed directly in the file instead of .zpreztorc
