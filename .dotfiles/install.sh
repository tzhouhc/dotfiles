#!/bin/bash
set -e

AUTO_YES=0
for arg in "$@"; do
  if [[ "$arg" == "-y" ]]; then
    AUTO_YES=1
    break
  fi
done

# setup installation environment to be consistent
this_path="$(realpath "$0")"
cwd=$(dirname "${this_path}")
cd "$cwd"

# make sure paths are set even if the corresponding binaries aren't installed
# yet; should be compatible with bash
source "$HOME/.zsh/env/path.zsh"

if [[ $XDG_CONFIG_HOME == '' ]]; then
  echo "No XDG_CONFIG_HOME set. Please verify you are running zsh."
  exit 1
fi

confirm() {
  # Usage: confirm "Question?"
  if [[ "$AUTO_YES" -eq 1 ]]; then
    return 0  # Always "yes" if -y was passed
  fi
  local response
  read -r -p "${1} [y/n]: " response
  [[ $response == "y" || $response == "Y" ]]
}

# fzf
if ! [ -d "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  yes 'n' | ~/.fzf/install  # download only
  echo "Installed FZF"
else
  echo "FZF already present"
fi

# zinit -- this should actually be automatic once zsh and dotfiles are setup
# pre
if ! [[ -d "$HOME/.local/share/zinit" ]]; then
  bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
else
  echo "Zinit already present"
fi

# make zoxide database dir
mkdir -p "$HOME/.data/zoxide"

# tpm
if ! [ -d "$XDG_CONFIG_HOME/tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$XDG_CONFIG_HOME/tmux/plugins/tpm"
  echo "Installing TPM"
else
  echo "TPM already installed"
fi

# install OS-dependent specific items
if uname -a | grep -i linux > /dev/null; then
  if type apt-get >/dev/null 2>&1; then
    sudo "$cwd"/install/apt.sh
  elif type yum >/dev/null 2>&1; then
    sudo "$cwd"/install/other/yum.sh
  elif type pacman >/dev/null 2>&1; then
    sudo "$cwd"/install/other/pacman.sh
  else
    echo "Unknown OS, some software installation incomplete."
  fi
fi

# homebrew
if ! type brew &>/dev/null; then
  # install homebrew using just gcc and build-essentials
  if confirm "Install homebrew and related?"; then
    "$cwd"/install/brew.sh
  fi
fi

# Update path to enable pip.sh?
if uname -a | grep -i darwin > /dev/null; then
  export BREW_HOME=/opt/homebrew
else
  export BREW_HOME=/home/linuxbrew/.linuxbrew
fi
export PATH=$BREW_HOME/bin:$PATH

# with cargo installed, tools like bob should all become available for
# subsequent use.
if ! type nvim &>/dev/null; then
  if confirm "Install neovim?"; then
    "$cwd"/install/core/nvim.sh
  fi

  pushd "$HOME/.config/nvim"
  git checkout main
  popd
else
  echo "Neovim already setup"
fi


# try to acquire latest binaries after installations
hash -r

# assumes python is already present and up-to-date
if confirm "Install python packages?"; then
  "$cwd"/install/pip.sh
fi

# install rust tools
if ! type cargo &>/dev/null; then
  if confirm "Install rust tools?"; then
    "$cwd"/install/cargo.sh
  fi
else
  echo "rust already present"
fi

# install zellij tools
if ! type zjframes.wasm &>/dev/null; then
  if confirm "Install zellij tools? (does not require zellij installed)"; then
    "$cwd"/install/zellij.sh
  fi
else
  echo "zellij tools already present"
fi

# setup LLM service credentials
if confirm "Setup Credentials?"; then
  "$cwd"/install/creds.sh
fi

# setup private data repo
if [[ -d "$HOME/.private.git" ]]; then
  echo "Private repo already setup."
else
  if confirm "Setup Private files repo?"; then
    git clone --bare git@github.com:tzhouhc/private.git "$HOME/.private.git"
    git --git-dir="$HOME/.private.git" --work-tree="$HOME" checkout -f
    "$HOME/.private/setup.sh"
  fi
fi

# setup squirrel config
if uname -a | grep -i darwin &>/dev/null; then
  if confirm "Setup Rime input?"; then
    "$cwd"/lib/rime/setup
  fi
fi

# setup for development in addition to just regular usage
if confirm "Setup for development?"; then
  "$cwd"/install/dev/brew_dev.sh

  # python package management
  if ! type uv &>/dev/null; then
    if confirm "Install uv?"; then
      curl -LsSf https://astral.sh/uv/install.sh | sh
    fi
  else
    echo "uv already present"
  fi
fi
