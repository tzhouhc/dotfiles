#!/bin/bash
set -e

# os-dependent brew home
if uname -a | grep -i darwin > /dev/null; then
  export BREW_HOME=/opt/homebrew
else
  export BREW_HOME=/home/linuxbrew/.linuxbrew
fi
export PATH=$BREW_HOME/bin:$PATH

brew update
# critical tools for development
brew install cloc bazel hyperfine gperftools graphviz llvm luarocks \
  pre-commit pandoc difftastic pnpm hexyl direnv universal-ctags
brew install --cask gcloud-cli
brew install --cask basictex

# gh extension
if ! gh auth status >/dev/null 2>&1; then
  echo "Logging into Github."
  # always use default github.com;
  # always use ssh key for auth;
  # always use web interface, which will fail, then perform the login manually
  # from the host.
  gh auth login -p ssh -h github.com -w
fi
gh extension install dlvhdr/gh-dash

if uname -a | grep -i darwin &>/dev/null; then
  echo "Installing macos packages."
fi
