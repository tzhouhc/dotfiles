#!/bin/bash

# current script location
cwd="$(dirname "$0")"
cwd="$(cd $cwd; pwd)"

ln -sf "$cwd/zshrc" "$HOME/.zshrc"
ln -sf "$cwd/zsh_aliases" "$HOME/.zsh_aliases"
ln -sf "$cwd/gitconfig" "$HOME/.gitconfig"
ln -sf "$cwd/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$cwd/ctags" "$HOME/.ctags"
