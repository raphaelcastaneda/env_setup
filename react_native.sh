#!/bin/bash

if [ ! -d  "$HOME/.nvm" ]; then

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    grep -qxF 'export NVM_DIR="$HOME/.nvm"' "$HOME"/.bashrc || echo 'export NVM_DIR="$HOME/.nvm"' >>  "$HOME"/.bashrc
    grep -qxF '[ -s "$NVM_DIR/nvm.sh"  ] && \. "$NVM_DIR/nvm.sh"' "$HOME"/.bashrc || echo '[ -s "$NVM_DIR/nvm.sh"  ] && \. "$NVM_DIR/nvm.sh"' >>  "$HOME"/.bashrc

    grep -qxF '[ -s "$NVM_DIR/bash_completion"  ] && \. "$NVM_DIR/bash_completion"' "$HOME"/.bashrc || echo '[ -s "$NVM_DIR/bash_completion"  ] && \. "$NVM_DIR/bash_completion"' >>  "$HOME"/.bashrc
fi

nvm install 16.19.0
nvm use  16.19.0

brew update
brew install yarn
brew install watchman
brew install libffi
brew install rbenv

rbenv init
grep -qxF 'eval "$(rbenv init -)"' "$HOME"/.bashrc || echo 'eval "$(rbenv init -)"' >>  "$HOME"/.bashrc
rbenv install 2.7.4
rbenv global 2.7.4
echo "gem: --no-document" > "$HOME"/.gemrc
gem install bundler:2.3.4

brew install git-lfs

brew install --cask adoptopenjdk/openjdk/adoptopenjdk11

brew --cask install flipper
brew tap facebook/fb
brew install idb-companion
pip install fb-idb

xcode-select --install
