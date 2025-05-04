#!/bin/bash
# the script is ideally completely idempotent

set -e

# fzf
if ! [ -d "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
  ~/.fzf/install
  echo "Installed FZF"
else
  echo "FZF already present"
fi

if ! [[ -d "$HOME/.local/share/zinit" ]]; then
  bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
else
  echo "Zinit already present"
fi


# current script location
cwd="$(dirname "$0")"
cwd="$(cd $cwd; pwd)"

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

echo "successfully deployed dotfiles."
