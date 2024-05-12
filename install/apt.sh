#!/bin/bash
set -e

apt-get update

apt-get install wget tmux zsh ctags silversearcher-ag \
  universal-ctags stow moreutils
