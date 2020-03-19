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
  #----------- START OSX section----------------------------
  # Homebrew stuff
  if test ! $(which brew)
  then
    echo "  Installing Homebrew for you."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  # Set up git line endings
  git config --global core.autocrlf input

  # Install OSX 10.14 headers
  #sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /

  # Install homebrew packages
  brew install python
  brew install coreutils
  brew install curl wget
  brew install git
  brew install tmux
  brew install tig
  brew install tree
  brew install graphviz
  brew install vim
  brew install tmuxinator
  brew install the_silver_searcher 
  brew install ssh-copy-id 
  brew install thefuck
  brew install ctags-exuberant
  brew install go
  brew install node
  brew install rust
  brew install lnav
  brew install cmake
  brew install mono # used for building omnisharp for C# completion in YCM
  brew install bash-completion@2
  brew install ncdu
  brew tap homebrew/cask
  brew cask install iterm2
  brew cask install hyperswitch
  brew cask install hyperdock 
  brew cask install slack
  brew cask install franz
  brew cask install skitch
  brew cask install sublime-text
  brew cask install bowtie
  brew cask install foxitreader
  
  # Make sure ycm can compile against this python
  export PYTHON_CONFIGURE_OPTS="--enable-framework"  

  # Switch to brew-installed bash
  sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
  chsh -s /usr/local/bin/bash

  #-------------- END OSX section-----------------------

else
  #----------- START Ubuntu section----------------------------
  # Add extra repos
  sudo add-apt-repository -y ppa:gophers/archive
  sudo add-apt-repository -y ppa:longsleep/golang-backports
  sudo add-apt-repository -y ppa:brightbox/ruby-ng
  sudo apt-get install -y software-properties-common

  #Get the latest stuff
  sudo apt-get update

  # Install debian packages
  sudo apt-get install -y  build-essential cmake gcc libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev
  sudo apt-get install -y git tig tree htop curl silversearcher-ag
  sudo apt-get install -y python python-pip vim python-dev thefuck
  sudo apt-get install -y ruby2.5
  sudo apt-get install -y exuberant-ctags libncurses-dev golang
  sudo apt-get install -y golang-go
  sudo apt-get install -y nodejs npm
  sudo apt-get install -y ncdu
  curl https://sh.rustup.rs -sSf | sh -s -- -y
  sudo apt-get install -y lnav
  sudo apt-get install -y bash-completion

  # Install tmux from source
  source ./tmux_build_from_source.sh
  
  # Install tmuxinator via ruby
  sudo gem install tmuxinator

  # Make sure ycm can compile against this python
  export PYTHON_CONFIGURE_OPTS="--enable-shared"  
  #----------- END Ubuntu section----------------------------
fi

# Set up Vundle
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

# File symlinks
for file in "bashrc" "bash_profile" "tmux.conf" "tmux.conf.sh" "Xresources" "vimrc"; do
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


# Clone pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
pushd $(pyenv root)
git pull
popd

# Make sure tmuxinator does not break things
mkdir -p ~/.bin
touch ~/.bin/tmuxinator.bash

# Use our new bashrc
source ~/.bashrc

# Set up pyenv
pyenv install --skip-existing 3.8.2
pyenv install --skip-existing 2.7.17
pyenv global 3.8.2

# Install python packages
python -m pip install virtualenv jedi pudb

# Install virtualenvwrapper pyenv plugin
git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git $(pyenv root)/plugins/pyenv-virtualenvwrapper

# Set up fonts
cd fonts
bash install.sh
cd ..

# Install fuzzy searcher fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all

# Install vim plugins
vim +PluginInstall +qall
cd ~/.vim/bundle/YouCompleteMe
git submodule update --init --recursive
npm install -g xbuild # required to build Omnisharp for ycm
python ~/.vim/bundle/YouCompleteMe/install.py --go-completer --all
vim +'silent :GoInstallBinaries' +qall
cd ~/.vim/bundle/YouCompleteMe/third_party/ycmd/third_party/go/src/golang.org/x/tools/cmd/gopls
go build
vim +'silent :call mkdp#util#install()' +qall

# Make sure .env exists if it didn't already
touch $HOME/.env

echo "All done!"
