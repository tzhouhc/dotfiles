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
  moreutils lazygit direnv jq gum age tldr mods taskwarrior-tui cargo-binstall

# less important ones
brew install hexyl numbat
brew install cmus difftastic btop pnpm
brew install timescam/homebrew-tap/pay-respects
