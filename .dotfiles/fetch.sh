#!/bin/bash
set -e

git clone --bare git@github.com:tzhouhc/dotfiles.git $HOME/.dotfiles.git
alias dfg='git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME'
dfg checkout -f
dfg submodule update --init --recursive
cp $HOME/.dotfiles/ref_git_config $HOME/.dotfiles.git/config

source $HOME/.dotfiles/install.sh
