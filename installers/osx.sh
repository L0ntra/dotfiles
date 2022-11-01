#!/bin/bash

# Brew


if [ $(type brew > /dev/null; echo $?) -ne 0 ] ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  touch ~/.zsh/env
  chmod 666 ~/.zsh/env
  echo "export PATH=\$PATH:/opt/homebrew/bin" >> ~/.zsh/env
fi

source ~/.zshrc

# Languages
brew install go scala sbt python
echo "export PATH=\$PATH:\$(go env GOPATH)/bin" >> ~/.zsh/env

go install golang.org/x/tools/cmd/goimports@latest


# Tools
brew install parquet-tools grep jq yq

# Cloud CLI
brew install docker awscli terraform
