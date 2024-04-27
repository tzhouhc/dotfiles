#!/bin/bash
set -e

if type cargo >/dev/null 2>&1; then
  cargo install du-dust  # better disk usage display
  cargo install eza   # ls
  cargo install bat   # less
  cargo install git-delta   # diff
  cargo install choose   # cut
  cargo install fd-find   # find
  cargo install just   # make
  cargo install bottom --locked  # top
  cargo install navi   # find
  cargo install ripgrep   # grep
  cargo install starship   # shell prompt
  cargo install zoxide   # z
  cargo install zellij   # tmux
  cargo install procs   # ps
  cargo install nu  # shell for data
fi

