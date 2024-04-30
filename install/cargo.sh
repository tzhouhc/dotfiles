#!/bin/bash
set -e

if type cargo >/dev/null 2>&1; then
  cargo install atuin  # shell history
  cargo install bat   # less
  cargo install bottom --locked  # top
  cargo install choose   # cut
  cargo install coreutils  # coreutils
  cargo install du-dust  # better disk usage display
  cargo install eza   # ls
  cargo install fd-find   # find
  cargo install git-delta   # diff
  cargo install just   # make
  cargo install navi   # find
  cargo install nu  # shell for data
  cargo install pipr  # pipeline crafter
  cargo install procs   # ps
  cargo install ripgrep   # grep
  cargo install rm-improved  # rm
  cargo install starship   # shell prompt
  cargo install zellij   # tmux
  cargo install zoxide   # z
else
  echo "cargo not found!"
fi
