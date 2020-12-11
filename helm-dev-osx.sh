#!/usr/bin/env bash

brew install kubectl
brew install hyperkit
brew install minikube
brew install helm
brew install terraform

minikube config set vm-driver hyperkit
