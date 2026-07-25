#!/bin/bash

# Languages
## GO 
sudo pacman -Sy go 
echo "export PATH=\$PATH:\$(go env GOPATH)/bin" >> ~/.zsh/env

go install golang.org/x/tools/cmd/goimports@latest


# Tools
sudo pacman -Sy jq yq

# Cloud CLI
sudo pacman -Sy docker docker-compose aws-cli-v2

# Config
sudo pacman -Sy direnv
