#!/bin/bash
set -e

uvi() {
  uv tool install --upgrade "$@"
}

uvi hererocks
uvi pynvim
uvi neovim-remote
uvi git-fame
uvi basedpyright
uvi ty
uvi pre-commit --with pre-commit-uv
