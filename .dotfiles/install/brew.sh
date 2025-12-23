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
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update
# critical tools
brew install wget git tmux zsh moreutils lazygit jq tldr \
  coreutils nodejs python@3.13 grep ast-grep clipboard btop gh \
  charmbracelet/tap/crush

# linux sometimes don't have prebuilt binaries in arm64
if [[ $(uname -m) == "aarch64" && $(uname -s) == "Linux" ]]; then
  brew install --build-from-source gum age mods oh-my-posh
else
  brew install gum age mods oh-my-posh
fi
