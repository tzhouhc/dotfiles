#!/bin/bash
set -e

apt-get update

apt-get install build-essential pkg-config libssl-dev cmake wget tmux zsh \
  silversearcher-ag stow moreutils

# non-apt or apt doesn't have latest

# cd $HOME/downloads/
# wget https://ftp.gnu.org/gnu/stow/stow-2.4.0.tar.gz
# tar -xf stow-2.4.0.tar.gz
# pushd stow-2.4.0
# ./configure
# sudo make install
# popd

# git clone https://github.com/universal-ctags/ctags.git
# cd ctags
# ./autogen.sh
# ./configure
# make
# sudo make install
