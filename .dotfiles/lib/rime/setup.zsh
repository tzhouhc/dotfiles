#!/usr/bin/env zsh

source $HOME/.zsh/base.zsh
# stow needs to run from the dir containing the files to link.
cd "$(dirname "$0")"

if uname -a | grep -i darwin &>/dev/null; then
  # Rime config directory is fixed on macos;
  # also make sure to exclude self
  stow --target="${HOME}/Library/Rime" --ignore="setup.*" .
fi

