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
if [[ $(uname -m) == "aarch64" && $(uname -s) == "Linux" ]]; then
  brew install wget git tmux zsh the_silver_searcher universal-ctags \
    moreutils lazygit direnv jq tldr cargo-binstall \
    coreutils nodejs python@3.13 grep
  brew install --build-from-source gum age mods oh-my-posh
else
  brew install wget git tmux zsh the_silver_searcher universal-ctags \
    moreutils lazygit direnv jq gum age tldr mods cargo-binstall \
    coreutils nodejs oh-my-posh python@3.13 grep
fi

# less important ones
brew install hexyl numbat pastel wtfutil clipboard
brew install difftastic btop pnpm gh
brew install timescam/homebrew-tap/pay-respects
brew install charmbracelet/tap/crush

# gh extension
gh extension install dlvhdr/gh-dash

if uname -a | grep -i darwin &>/dev/null; then
  # chinese input method
  brew install --cask squirrel
  brew tap laishulu/homebrew
  brew install macism
  # music player
  brew install cmus
fi
