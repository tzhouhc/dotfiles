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

config_dir="$cwd/configs"
# for XDG_CONFIG_HOME
xdg_source_dir="$cwd/xdg_configs"
xdg_dir="$HOME/.config"
mkdir -p $xdg_dir

# potentially the one introduced by oh-my-zsh
# removing and relinking is idempotent
if [ -e "$HOME/.zshrc" ]; then
  rm $HOME/.zshrc
fi

# make zoxide database dir
mkdir -p "$HOME/.data/zoxide"

# Use stow to manage symlinks
#
# stow _superficially_ does not allow source to contain slashes,
# but we can simply make sure to call it from the containing directory.
# Link all $HOME dotfiles, including the various RC files and zsh dir.
stow --dotfiles -v --target="$HOME" "configs"
stow --dotfiles -v --target="$xdg_dir" "xdg_configs"

# tpm
if ! [ -d "$xdg_dir/tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm $xdg_dir/tmux/plugins/tpm
  echo "Installing TPM"
else
  echo "TPM already installed"
fi

# setting up variation software
if type fdfind 2>/dev/null; then
  ln -sf $(which fdfind) "$HOME/.local/bin/fd"
fi

echo "successfully deployed dotfiles."
