#!/bin/bash

# install brew if none present
if type brew >/dev/null; then
else
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update

brew install bat neovim fd tmux zsh
