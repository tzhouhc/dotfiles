#!/bin/bash
set -e

uvi() {
  uv tool install --upgrade "$@"
}

# neovim provider
uvi pynvim --with neovim

# sbin tools
uvi hererocks
uvi neovim-remote
uvi git-fame
uvi basedpyright
uvi ty
uvi pre-commit --with pre-commit-uv
