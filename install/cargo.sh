#!/bin/bash
set -e

export PATH=$HOME/.cargo/bin:$PATH

# install rust for cargo -- OS agnostic, more or less
if ! type cargo >/dev/null 2>&1; then
  echo "Installing rust/cargo:"
  curl https://sh.rustup.rs -sSf | sh
fi

if type cargo >/dev/null 2>&1; then
  cargo install bat   # less
  cargo install bob-nvim  # nvim manager
  cargo install choose   # cut
  cargo install eza   # ls
  cargo install fd-find   # find
  cargo install git-delta   # diff
  cargo install imgcatr  # show images
  cargo install just   # make
  cargo install navi   # find
  cargo install ripgrep --features 'pcre2'  # grep
  cargo install rm-improved  # rm
  cargo install starship   # shell prompt
  cargo install zoxide   # z
else
  echo "cargo not found!"
fi
