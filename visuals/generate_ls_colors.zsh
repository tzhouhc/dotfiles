#!/usr/bin/env zsh

cwd="$(dirname "$0")"
cwd="$(cd $cwd; pwd)"

vivid -d ./filetypes.yml generate lscolors.yml > lscolors
