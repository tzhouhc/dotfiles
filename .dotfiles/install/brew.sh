#!/bin/bash
set -e

# os-dependent brew home
if uname -a | grep -i darwin > /dev/null; then
  export BREW_HOME=/opt/homebrew
else
  export BREW_HOME=/home/linuxbrew/.linuxbrew
fi
export PATH=$BREW_HOME/bin:$PATH

# install brew if none present
if ! type brew  >/dev/null 2>&1; then
  echo "Installing homebrew:"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update
# critical tools
brew install wget git tmux zsh the_silver_searcher universal-ctags \
  moreutils lazygit direnv jq gum age tldr mods taskwarrior-tui cargo-binstall \
  coreutils nodejs oh-my-posh python@3.13 grep

# less important ones
brew install hexyl numbat pastel wtfutil
brew install cmus difftastic btop pnpm gh
brew install timescam/homebrew-tap/pay-respects
brew install charmbracelet/tap/crush

if uname -a | grep -i darwin &>/dev/null; then
  # chinese input method
  brew install --cask squirrel
  brew tap laishulu/homebrew
  brew install macism
fi
