env_setup
========

Dotfiles inspired by [kiasaki](https://github.com/kiasaki/dotfiles) and [mathias](https://github.com/mathiasbynens/dotfiles)

## Install on a new computer

```
cd ~
git clone git@github.com:raphaelcastaneda/env_setup.git
cd env_setup
./setup.sh
```

## Contents

Mostly config for the following:

- Vim
- Git
- Git helpers
- Bash shell
- Bash aliases and shortcuts
- tmux
- Python

## A note about powerline for vim
This will install [Powerline](https://github.com/powerline/powerline) for vim but you may find that the symbols are not properly rendered by the system default font. setup.sh will handle
installing the fonts for you, but you must enable one of the patched powerline fonts as the non-ascii font in your terminal.
I recommend DejaVu Sans Mono for powerline
