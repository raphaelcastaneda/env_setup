env_setup
========

Dotfiles based blatantly stolen from [kiasaki](https://github.com/kiasaki/dotfiles)

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

## Vim setup
The first time you launch vim, you must do the following to install the selected plugins:
```
:BundleInstall
```
Also note that this installs [Powerline](https://github.com/powerline/powerline). setup.sh will handle
installing the fonts for you, but you must enable one of the patched powerline fonts as the non-ascii font in your terminal.
I recommend DejaVu Sans Mono for powerline
