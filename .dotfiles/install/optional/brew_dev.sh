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
# critical tools
brew install cloc bazel hyperfine gperftools graphviz llvm luarocks
brew install --cask gcloud-cli
brew install --cask basictex

if uname -a | grep -i darwin &>/dev/null; then
  echo "Installing macos packages."
fi
