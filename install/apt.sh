#!/bin/bash
set -e

apt-get update

apt-get install wget neovim fd-find bat tmux zsh ctags silversearcher-ag

# need ripgrep
wget 'https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb' -O /tmp/rg.deb
dpkg -i /tmp/rg.deb
rm /tmp/rg.deb