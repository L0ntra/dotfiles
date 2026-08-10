#!/bin/bash

BASEDIR=$(pwd)

## Create Symlinks
# zsh
ln -s ${BASEDIR}/zshrc ~/.zshrc
ln -s ${BASEDIR}/zsh ~/.zsh

# ghostty
ln -s ${BASEDIR}/ghostty ~/.config/ghostty

touch ${BASEDIR}/zsh/env


