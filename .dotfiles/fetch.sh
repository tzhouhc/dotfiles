#!/bin/bash
set -e

if uname -a | grep -i linux > /dev/null; then
  if type apt >/dev/null 2>&1; then
    sudo apt install -y zsh git curl
  elif type yum >/dev/null 2>&1; then
    sudo yum install -y zsh git curl
  elif type pacman >/dev/null 2>&1; then
    sudo pacman -S --noconfirm zsh git curl
  else
    echo "Unable to setup bootstrap!"
    exit 1
  fi
fi

# ensure user has password
if [[ $(passwd --status | cut -d' ' -f2) == "L" ]]; then
  sudo passwd "$(whoami)"
fi

dfg() {
  git --git-dir="$HOME/.dotfiles.git" --work-tree="$HOME" "$@"
}

git clone --bare git@github.com:tzhouhc/dotfiles.git "$HOME/.dotfiles.git"

dfg checkout -f
dfg submodule update --init --recursive

cp "$HOME/.dotfiles/ref_git_config" "$HOME/.dotfiles.git/config"

export XDG_CONFIG_HOME="$HOME/.config"
mkdir -p "$XDG_CONFIG_HOME"
cd "$HOME/.dotfiles/"
# source instead of run to keep some env consistency (?)
source install.sh
