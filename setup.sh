#!/bin/bash

BASEDIR=$(pwd)

## Create Symlinks
# Skips any link whose target already exists so re-running is safe.
link() {
  local src=$1 dst=$2
  if [ -e "${dst}" ] || [ -L "${dst}" ]; then
    echo "skip:  ${dst} already exists"
  else
    ln -s "${src}" "${dst}"
    echo "link:  ${dst} -> ${src}"
  fi
}

# zsh
link ${BASEDIR}/zshrc ~/.zshrc
link ${BASEDIR}/zsh ~/.zsh

# ghostty
if [ "$(uname)" = "Darwin" ]; then
  link "${BASEDIR}/ghostty" ~/Library/Application\ Support/com.mitchellh.ghostty
else
  link "${BASEDIR}/ghostty" ~/.config/ghostty
fi

# claude code
mkdir -p ~/.claude
link ${BASEDIR}/claude/commands ~/.claude/commands
link ${BASEDIR}/claude/skills ~/.claude/skills
link ${BASEDIR}/claude/settings.json ~/.claude/settings.json

touch ${BASEDIR}/zsh/env
