#!/usr/bin/env bash

brew install kubectl
brew install derailed/k9s/k9s  # cli GUI for kubernetes management
brew install docker docker-compose
mkdir -p ~/.docker/cli-plugins
ln -sfn $(brew --prefix)/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose
brew install colima  # run colima start --kubernetes
brew install helm
brew install terraform
