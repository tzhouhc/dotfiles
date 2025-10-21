#!/bin/bash
set -e

export PATH=$HOME/.cargo/bin:$PATH

# install rust for cargo -- OS agnostic, more or less
if ! type cargo >/dev/null 2>&1; then
  echo "Installing rust/cargo:"
  curl https://sh.rustup.rs -sSf | sh
fi

echo "Installing cargo-binstall"
if type brew &>/dev/null; then
  brew install cargo-binstall
else
  curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
fi

if type cargo >/dev/null 2>&1; then
  cargo binstall -y atuin  # shell history
  cargo binstall -y bat   # less
  cargo binstall -y choose   # cut
  cargo binstall -y du-dust  # better disk usage display
  cargo binstall -y eza   # ls
  cargo binstall -y fd-find   # find
  cargo binstall -y git-delta   # diff
  cargo binstall -y imgcatr  # show images
  cargo binstall -y jnv   # interactive jq
  cargo binstall -y just   # make
  cargo binstall -y navi   # find
  cargo binstall -y petname  # random name generator
  cargo binstall -y zellij  # tmux
  cargo install ripgrep --features 'pcre2'  # grep
  cargo binstall -y rm-improved  # rm
  cargo binstall -y yazi-fm yazi-cli  # file explorer
  cargo binstall -y zoxide   # z
else
  echo "cargo not found!"
fi
