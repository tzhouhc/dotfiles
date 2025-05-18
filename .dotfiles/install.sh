#!/bin/bash
set -e

if [[ $TMUX == '' ]]; then
  echo "Not running in tmux. This is not ideal for running the installation."
  exit 1
fi

cwd="$(dirname "$0")"
cd $cwd

# install OS-dependent specific items
if uname -a | grep -i linux > /dev/null; then
  if type apt-get >/dev/null 2>&1; then
    sudo $cwd/install/apt.sh
  elif type yum >/dev/null 2>&1; then
    sudo $cwd/install/yum.sh
  elif type pacman >/dev/null 2>&1; then
    sudo $cwd/install/pacman.sh
  else
    echo "Unknown OS, remainder of software installation incomplete."
    exit 1
  fi
fi

# make sure paths are set even if the corresponding binaries aren't installed
# yet; should be compatible with bash
source $HOME/.zsh/env/path.zsh

# install homebrew using just gcc and build-essentials
read -r -p "Install homebrew and related? [y/n]: " response
if [[ $response == "y" || $response == "Y" ]]; then
  source $cwd/install/brew.sh
fi

# with cargo installed, tools like bob should all become available for
# subsequent use.
read -r -p "Install neovim? [y/n]: " response
if [[ $response == "y" || $response == "Y" ]]; then
  source $cwd/install/core/nvim.sh
fi

# assumes python is already present and up-to-date
read -r -p "Install python packages? [y/n]: " response
if [[ $response == "y" || $response == "Y" ]]; then
  source $cwd/install/pip.sh
fi

# install rust tools
read -r -p "Install rust tools? [y/n]: " response
if [[ $response == "y" || $response == "Y" ]]; then
  source $cwd/install/cargo.sh
fi

# install zellij tools
read -r -p "Install zellij tools? (does not require zellij installed) [y/n]: " response
if [[ $response == "y" || $response == "Y" ]]; then
  source $cwd/install/zellij.sh
fi
