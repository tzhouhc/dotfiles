#!/bin/bash
set -e

export PATH=$HOME/.cargo/bin:$PATH

if type cargo >/dev/null 2>&1; then
  cargo binstall -y erdtree   # tree
  cargo binstall -y imgcatr  # show images; no binstall
  cargo binstall -y jnv   # interactive jq
  cargo binstall -y magika-cli   # file; no binstall
  cargo install ripgrep --features 'pcre2'  # grep
  cargo binstall -y petname  # random name generator
else
  echo "cargo not found!"
fi

