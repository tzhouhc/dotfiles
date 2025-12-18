#!/bin/bash
set -e

# fonts (universal)
brew install font-victor-mono font-cascadia-code font-scientifica
brew install sing-box

# macos exclusive
if uname -a | grep -i darwin &>/dev/null; then
  # commonly used apps
  brew install --cask google-chrome wezterm@nightly hammerspoon
  brew install --cask raycast alt-tab topnotch bartender \
    discord ticktick obsidian
  # chinese input method
  brew install --cask squirrel-app
  # proxy
  brew install --cask sfm
  # localsend
  brew install --cask localsend
fi
