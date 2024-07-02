#!/bin/bash


echo "Grabbing sudo creds because installs will need them"
sudo echo "muahahahaha"

# Directories
env_setup=$HOME/env_setup
for directory in \
  "$HOME/code" "$HOME/.vim" "$HOME/.vim/autoload" "$HOME/.vim/swaps" \
  "$HOME/.vim/backups" "$HOME/.vim/undo" "$HOME/.vim/colors" "$HOME/vimwiki" "$HOME/bin"; do
   mkdir -p "$directory"
done

osx=false
if [[ "$OSTYPE" == "darwin"* ]]; then
  osx=true
fi

if "$osx"; then
  #----------- START MacOS section----------------------------
  # Homebrew stuff
  if test ! "$(which brew)"
  then
    echo "  Installing Homebrew for you."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> $HOME/.bash_profile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  # Set up some sane git global config
  git config --global core.autocrlf input  # Leave line endings as-is
  git config --global pull.ff only  #  Abort git pull if it isn't a fast-forward

  # Install OSX 10.14 headers
  #sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /

  # Install homebrew packages
  brew install python
  brew install temurin  # java runtime
  brew install coreutils
  brew install curl wget
  brew install git
  brew install tmux
  brew install tig
  brew install tree
  brew install graphviz
  #brew install vim
  brew install --HEAD neovim
  brew install tmuxinator
  brew install ranger  # terminal file manager with vim bindings
  brew install the_silver_searcher 
  brew install ripgrep  # used with fzf-vim-commands for awesome find-in-files text search
  brew install fd  # like silver searcher but for find instead of grep
  brew install bat # github.com/sharkdp/bat syntax highlighted previews for fzf, git diff and others
  brew install task tasksh # taskwarrior - better task management
  brew install grandperspective # hard disk usage auditor
  brew install ssh-copy-id 
  brew install thefuck
  brew install ctags-exuberant
  brew install go
  brew install node
  brew install rust
  brew install lnav
  brew install cmake
  brew install watch
  brew install figlet # used to render text into ascii text e.g. in presenting.vim
  brew install mono # used for building omnisharp for C# completion in YCM
  brew install bash-completion@2
  brew install ncdu  # powerful disk usage tool
  brew install jq # command line json parser
  brew install kitty  # terminal emulator with powerful font support
  brew install imagemagick  # command line image tool, allows kitty to display images
  brew install --cask hyperswitch
  brew install --cask hyperdock 
  brew install --cask slack
  brew install --cask ferdium  #  all-in-one chat app for browser-based chat
  brew install --cask skitch
  brew install --cask sublime-text
  brew install --cask beardedspice  # mac os media key forwarder (for spotify)
  brew install --cask foxitreader
  brew install --cask gimp
  brew install --cask diffmerge
  brew install --cask insomnium  # postman replacement-replacement
  brew install --cask dotnet-sdk
  brew install --cask joshjon-nocturnal  # sets nightshift to also affect external display
  brew install --cask cyberduck  # cloud server browser (ftp, amazon s3 etc)
  brew tap isen-ng/dotnet-sdk-versions
  brew install dotnet-sdk3-1-300
  brew install lua-language-server # LSP server for LUA (helps with neovim configs)
  brew install trash  # Helper that moves target to MacOs trash
  brew install yamlfmt
  brew install insomnium  # Insomnia replacement REST API client
  
  # Install fancy programming fonts
  brew tap homebrew/cask-fonts
  brew install --cask font-victor-mono-nerd-font
  brew install --cask font-fira-code-nerd-font
  
  # Make sure ycm can compile against this python
  export PYTHON_CONFIGURE_OPTS="--enable-framework"  

# Install K9s theme
OUT="${XDG_CONFIG_HOME:-$HOME/Library/Application Support}/k9s/skins"
mkdir -p "$OUT"
curl -L https://github.com/catppuccin/k9s/archive/main.tar.gz | tar xz -C "$OUT" --strip-components=2 k9s-main/dist

curl -L "https://raw.githubusercontent.com/derailed/k9s/master/skins/nightfox.yaml" -o "$OUT/nightfox.yaml"

# Local cloud development
source ./helm-dev-osx.sh # Install helm and terraform tools
zsh ./colima-dev-macos.sh
brew install skaffold
skaffold config set --global collect-metrics false

  #-------------- END MacOs section-----------------------

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
  sudo apt-get install -y neovim python-3-neovim
  sudo apt-get install -y taskwarrior  # task management
  sudo apt-get install -y ranger-fm
  sudo apt-get install -y  build-essential cmake gcc libssl-dev zlib1g-dev libbz2-dev \
  libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
  xz-utils tk-dev
  sudo apt-get install -y git tig tree htop curl silversearcher-ag
  sudo apt-get install -y ripgrep bat
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


# File symlinks
for file in "bashrc" "bash_profile" "tmux.conf" "tmux.conf.sh" "Xresources" "vimrc" ".tigrc"; do
  rm -rf "$HOME/.$file"
  ln -s "$env_setup/$file" "$HOME/.$file"
done

# Symlink .config folder
if [ -d "$HOME/.config" ]; then
  echo "Existing config folder present. Backing up to .config-backup"
  mv "$HOME/.config" "$HOME/.config-backup"
fi
ln -s "$env_setup/.config" "$HOME/.config"
#
# Symlink bin folder
ln -s "$env_setup/bin" "$HOME/bin"
# File copies
if [ ! -f "$HOME/.vim/colors/hybrid.vim" ]; then
  cp "$env_setup/vim/hybrid.vim" "$HOME/.vim/colors/hybrid.vim"
fi
if [ ! -f "$HOME/.gitconfig" ]; then
  cp "$env_setup/gitconfig" "$HOME/.gitconfig"
fi

# Set up bat color theme
mkdir -p "$(bat --config-dir)/themes"
cp "$env_setup/colors/Tomorrow-Night.tmTheme" "$(bat --config-dir)/themes/"
bat cache --build



# Clone pyenv
if [ ! -d "$HOME/.pyenv" ]; then
  git clone https://github.com/pyenv/pyenv.git "$HOME/.pyenv"
  pushd "$HOME/.pyenv"
  git pull
  popd
fi

# Make sure .env exists if it didn't already
touch "$HOME"/.env

# Make sure tmuxinator does not break things
mkdir -p ~/.bin
touch ~/.bin/tmuxinator.bash

# Use our new bashrc
source ~/.bashrc

# Set up pyenv
pyenv install --skip-existing 3.9.16
#pyenv install --skip-existing 2.7.17  # python is dead! long live python!
pyenv global 3.9.16

# Install python packages
python -m pip install --upgrade pip
python -m pip install virtualenv pynvim pudb bpytop
python -m pip install tasklib taskwarrior packaging # for taskwarrior integration with vimwiki

# Install virtualenvwrapper pyenv plugin
git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git "$(pyenv root)"/plugins/pyenv-virtualenvwrapper

# Install fuzzy searcher fzf and kube plugin
git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME"/.fzf
"$HOME"/.fzf/install --all
wget https://raw.githubusercontent.com/bonnefoa/kubectl-fzf/main/shell/kubectl_fzf.bash -O ~/.kubectl_fzf.bash
go install github.com/bonnefoa/kubectl-fzf/v3/cmd/kubectl-fzf-completion@main
go install github.com/bonnefoa/kubectl-fzf/v3/cmd/kubectl-fzf-server@main

# Install go environment manager
git clone https://github.com/go-nv/goenv.git ~/.goenv

# Install neovim plugins
if [ -d "$HOME/.local/share/nvim/site/pack/packer" ]; then
  git clone --depth 1 https://github.com/wbthomason/packer.nvim\
   "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
fi
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'


# Switch to brew-installed bash
sudo bash -c 'echo "$(which bash)" >> /etc/shells'
chsh -s "$(which bash)"

echo "All done!"
