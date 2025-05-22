#!/bin/bash
set -e

export PATH=$HOME/.cargo/bin:$PATH

# install rust for cargo -- OS agnostic, more or less
if ! type cargo >/dev/null 2>&1; then
  echo "Installing rust/cargo:"
  curl https://sh.rustup.rs -sSf | sh
fi

if type cargo >/dev/null 2>&1; then
  cargo binstall atuin  # shell history
  cargo binstall bat   # less
  cargo binstall bob-nvim  # nvim manager
  cargo binstall choose   # cut
  cargo binstall eza   # ls
  cargo binstall fd-find   # find
  cargo binstall git-delta   # diff
  cargo binstall imgcatr  # show images
  cargo binstall just   # make
  cargo binstall navi   # find
  cargo install --git https://github.com/lotabout/rargs.git  # xargs
  cargo binstall petname  # random name generator
  cargo install ripgrep --features 'pcre2'  # grep
  cargo binstall rm-improved  # rm
  cargo install --locked yazi-fm yazi-cli  # file explorer
  cargo binstall zoxide   # z
else
  echo "cargo not found!"
fi
