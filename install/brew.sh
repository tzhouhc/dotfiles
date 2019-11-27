#!/bin/bash

# install brew if none present
if type brew >/dev/null; then
else
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update

brew install wget bat neovim fd tmux zsh ctags the_silver_searcher ripgrep
