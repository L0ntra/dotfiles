#!/bin/bash

# Languages
## GO 
sudo pacman -S go 
echo "export PATH=\$PATH:\$(go env GOPATH)/bin" >> ~/.zsh/env

go install golang.org/x/tools/cmd/goimports@latest


# Tools
sudo pacman -S jq yq

# Cloud CLI
sudo pacman -S docker docker-compose aws-cli-v2

# Config
## Key Mapper
sudo pacman -S keyd
