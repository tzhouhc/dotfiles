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
brew install wget git tmux zsh moreutils lazygit jq tldr \
  coreutils nodejs python@3.13 grep clipboard btop gh \
  charmbracelet/tap/crush

# linux sometimes don't have prebuilt binaries in arm64
if [[ $(uname -m) == "aarch64" && $(uname -s) == "Linux" ]]; then
  brew install --build-from-source gum age mods oh-my-posh
else
  brew install gum age mods oh-my-posh
fi

if uname -a | grep -i darwin &>/dev/null; then
  # fonts
  brew install font-victor-mono font-cascadia-code
  # commonly used apps
  brew install --cask google-chrome wezterm@nightly hammerspoon
  brew install --cask raycast alt-tab topnotch bartender \
    discord ticktick obsidian
  # chinese input method
  brew install --cask squirrel-app
  brew tap laishulu/homebrew
  brew install macism
  # proxy
  brew install sing-box
  brew install --cask sfm
  # localsend
  brew install --cask localsend
fi
