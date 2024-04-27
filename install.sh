#!/bin/bash
set -e

cwd="$(dirname "$0")"
cwd="$(cd $cwd; pwd)"

# install rust for cargo -- OS agnostic, more or less
curl https://sh.rustup.rs -sSf | sh
source $cwd/install/cargo.sh

# install OS-dependent specific items
if uname -a | grep -i darwin > /dev/null; then
  $cwd/install/brew.sh
else
  if type apt-get >/dev/null 2>&1; then
    sudo $cwd/install/apt.sh
  fi
fi

# assumes python is already present and up-to-date
source $cwd/install/pip.sh
