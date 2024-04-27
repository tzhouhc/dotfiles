#!/bin/bash

if ! type "pip3" > /dev/null; then
  echo "No pip3 found!"
  exit 1
fi

# neovim compat and nvr for client-server mode
pip3 install ranger-fm neovim neovim-remote
