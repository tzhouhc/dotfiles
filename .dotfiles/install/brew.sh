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
  moreutils lazygit direnv jq tldr cargo-binstall \
  coreutils nodejs python@3.13 grep pre-commit
brew install charmbracelet/tap/crush
# less important ones
brew install hexyl numbat pastel wtfutil clipboard
brew install difftastic btop pnpm gh

# linux sometimes don't have prebuilt binaries in arm64
if [[ $(uname -m) == "aarch64" && $(uname -s) == "Linux" ]]; then
  brew install --build-from-source gum age mods oh-my-posh
else
  brew install gum age mods oh-my-posh
fi

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
