#!/bin/bash

BASEDIR=$(pwd)

## Create Symlinks
# zsh
ln -s ${BASEDIR}/zshrc ~/.zshrc
ln -s ${BASEDIR}/zsh ~/.zsh

touch ${BASEDIR}/zsh/env


