#!/bin/bash
set -e

# setup installation environment to be consistent
cwd="$(dirname "$0")"
cd $cwd

# make sure paths are set even if the corresponding binaries aren't installed
# yet; should be compatible with bash
source $HOME/.zsh/env/path.zsh

# check resumable context
if [[ $TMUX == '' ]]; then
  echo "Not running in tmux. This is not ideal for running the installation."
  read -r -p "Proceed anyway? [y/n]: " response
  if ! [[ $response == "y" || $response == "Y" ]]; then
    exit 1
  fi
fi

# fzf
if ! [ -d "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
  ~/.fzf/install
  echo "Installed FZF"
else
  echo "FZF already present"
fi

# zinit
if ! [[ -d "$HOME/.local/share/zinit" ]]; then
  bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
else
  echo "Zinit already present"
fi

# make zoxide database dir
mkdir -p "$HOME/.data/zoxide"

# tpm
if ! [ -d "$XDG_CONFIG_HOME/tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm $XDG_CONFIG_HOME/tmux/plugins/tpm
  echo "Installing TPM"
else
  echo "TPM already installed"
fi

# setting up variation software
if type fdfind 2>/dev/null; then
  ln -sf $(which fdfind) "$HOME/.local/bin/fd"
fi

# install OS-dependent specific items
if uname -a | grep -i linux > /dev/null; then
  if type apt-get >/dev/null 2>&1; then
    sudo $cwd/install/apt.sh
  elif type yum >/dev/null 2>&1; then
    sudo $cwd/install/other/yum.sh
  elif type pacman >/dev/null 2>&1; then
    sudo $cwd/install/other/pacman.sh
  else
    echo "Unknown OS, remainder of software installation incomplete."
    exit 1
  fi
fi

# install homebrew using just gcc and build-essentials
read -r -p "Install homebrew and related? [y/n]: " response
if [[ $response == "y" || $response == "Y" ]]; then
  $cwd/install/brew.sh
fi

# with cargo installed, tools like bob should all become available for
# subsequent use.
read -r -p "Install neovim? [y/n]: " response
if [[ $response == "y" || $response == "Y" ]]; then
  $cwd/install/core/nvim.sh
fi

# assumes python is already present and up-to-date
read -r -p "Install python packages? [y/n]: " response
if [[ $response == "y" || $response == "Y" ]]; then
  $cwd/install/pip.sh
fi

# install rust tools
read -r -p "Install rust tools? [y/n]: " response
if [[ $response == "y" || $response == "Y" ]]; then
  $cwd/install/cargo.sh
  $cwd/install/optional/cargo_optional.sh
  $cwd/install/optional/cargo_secondary.sh
fi

# install zellij tools
read -r -p "Install zellij tools? (does not require zellij installed) [y/n]: " response
if [[ $response == "y" || $response == "Y" ]]; then
  $cwd/install/zellij.sh
fi

# setup LLM service credentials
read -r -p "Setup LLM credentials? [y/n]: " response
if [[ $response == "y" || $response == "Y" ]]; then
  $cwd/install/creds.sh
fi
