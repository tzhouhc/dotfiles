#!/bin/bash
set -e

# os-dependent brew home
if uname -a | grep -i darwin > /dev/null; then
  export BREW_HOME=/opt/homebrew
else
  export BREW_HOME=/home/linuxbrew/.linuxbrew
fi
export PATH=$BREW_HOME/bin:$PATH

brew update
brew install pastel numbat

if uname -a | grep -i darwin &>/dev/null; then
  # music player
  brew install cmus
  # multimedia stuff
  brew install imagemagick ffmpeg
fi
