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
source $cwd/install/brew.sh

# install rust tools
source $cwd/install/cargo.sh

# with cargo installed, tools like bob should all become available for
# subsequent use.
source $cwd/install/nvim.sh

# assumes python is already present and up-to-date
source $cwd/install/pip.sh
