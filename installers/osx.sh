#!/bin/bash

# Brew


if [ $(type brew > /dev/null; echo $?) -ne 0 ] ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo "export PATH=\$PATH:/opt/homebrew/bin" >> ~/.zsh/env
fi

# Languages
brew install go scala python


# Tools
brew install parquet-tools grep jq yq

# Cloud CLI
brew install docker awscli terraform
