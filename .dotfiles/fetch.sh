#!/bin/bash
set -e

# ensure user has password
if [[ $(passwd --status | cut -d' ' -f2) == "L" ]]; then
  echo "You have not set a password yet. Setting up now."
  sudo passwd "$(whoami)"
fi

# ensure git (curl is likely already used; zsh won't be needed yet)
if uname -a | grep -i linux > /dev/null; then
  if type apt >/dev/null 2>&1; then
    sudo apt install -y git
  elif type apk >/dev/null 2>&1; then
    sudo apk add git
  elif type dnf >/dev/null 2>&1; then
    sudo dnf instal -y git-all
  elif type yum >/dev/null 2>&1; then
    sudo yum install -y git
  elif type pacman >/dev/null 2>&1; then
    sudo pacman -S --noconfirm git
  else
    echo "Unable to setup bootstrap!"
    exit 1
  fi
fi

dfg() {
  git --git-dir="$HOME/.dotfiles.git" --work-tree="$HOME" "$@"
}

# prevent git clone pubkey verification
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
git clone --bare git@github.com:tzhouhc/dotfiles.git "$HOME/.dotfiles.git"

dfg checkout -f
# this should setup XDG_CONFIG_HOME and nvim
dfg submodule update --init --recursive

# ensure dotfiles git config
cp "$HOME/.dotfiles/ref_git_config" "$HOME/.dotfiles.git/config"

export XDG_CONFIG_HOME="$HOME/.config"
mkdir -p "$XDG_CONFIG_HOME"
# install.sh assumes some pathing
pushd "$HOME/.dotfiles/"

# Pick a mode of installation
read -r -p "Choose install mode (base/dev/ask/full) [ask]: " INSTALL_MODE
if [[ -z "$INSTALL_MODE" ]]; then
  INSTALL_MODE="ask"
fi
# source instead of run to keep some env consistency (?)
source install.sh "$INSTALL_MODE"
popd

# clean up current script
rm "$0"
