#!/bin/bash 


# Directories
env_setup=$HOME/env_setup
for directory in \
  "$HOME/code" "$HOME/.vim" "$HOME/.vim/autoload" "$HOME/.vim/swaps" \
  "$HOME/.vim/backups" "$HOME/.vim/undo" "$HOME/.vim/colors" "$HOME/vimwiki"; do
   mkdir -p $directory
done

osx=false
if [[ "$OSTYPE" == "darwin"* ]]; then
  osx=true
fi

if $osx; then
  # Homebrew stuff
  if test ! $(which brew)
  then
    echo "  Installing Homebrew for you."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  # Set up git line endings
  git config --global core.autocrlf input

  # Install homebrew packages
  brew install python
  brew install pyenv pyenv-virtualenv
  brew install coreutils curl wget git tmux tig tree graphviz vim neovim
  brew install the_silver_searcher ssh-copy-id thefuck
  brew install ctags-exuberant
  brew install caskroom/cask/brew-cask
  brew cask install iterm2 nosleep hyperswitch hyperdock slack adium skitch sublime-text
else
  # Add extra repos
  sudo add-apt-repository -y ppa:neovim-ppa/stable

  # Get the latest stuff
  sudo apt-get update

  # Install debian packages
  sudo apt-get install -y build-essential gcc cmake zlib1g-dev
  sudo apt-get install -y git tig tree htop curl silversearcher-ag tmux
  sudo apt-get install -y python python-pip vim python-dev thefuck
  sudo apt-get install -y exuberant-ctags libncurses-dev golang
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv
fi

# Install python packages
if $osx; then
  pip install virtualenv virtualenvwrapper jedi pudb
else
  sudo pip install virtualenv virtualenvwrapper jedi pudb
fi

# Set up Vundle
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

# File symlinks
for file in "bashrc" "bash_profile" "tmux.conf" "Xresources" "vimrc"; do
  rm -rf "$HOME/.$file"
  ln -s "$env_setup/$file" "$HOME/.$file"
done

# File copies
if [ ! -f "$HOME/.vim/colors/hybrid.vim" ]; then
  cp "$env_setup/vim/hybrid.vim" "$HOME/.vim/colors/hybrid.vim"
fi
if [ ! -f "$HOME/.gitconfig" ]; then
  cp "$env_setup/gitconfig" "$HOME/.gitconfig"
fi

# Set up fonts
source ./fonts/install.sh

# Install fuzzy searcher fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install

# Install vim plugins
vim +PluginInstall +qall
python ~/.vim/bundle/YouCompleteMe/install.py

echo "All done!"
