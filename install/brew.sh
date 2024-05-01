#!/bin/bash
set -e

# install brew if none present
if ! type brew >/dev/null; then
  echo "Installing homebrew:"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update

brew install wget stow tmux zsh the_silver_searcher universal-ctags
