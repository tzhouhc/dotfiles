#!/bin/bash
set -e

if type cargo >/dev/null 2>&1; then
  cargo install du-dust  # better disk usage display
  cargo install eza   # ls
  cargo install bat   # less
  cargo install git-delta   # diff
  cargo install --locked broot   # tree
  cargo install choose   # cut
  cargo install fd-find   # find
  cargo install ripgrep   # grep
  cargo install starship   # grep
  cargo install zoxide   # z
  cargo install zellij   # tmux
  cargo install procs   # ps
fi

