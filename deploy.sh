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
# zgen (handles zsh)
if ! [ -e "$HOME/.zgen" ]; then
  git clone https://github.com/tarjoilija/zgen.git $HOME/.zgen
  echo "Installed Zgen"
else
  echo "Zgen already present"
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

# link config files; -f flag makes it idempotent
ln -sf "$cwd/zshrc" "$HOME/.zshrc"
ln -sf "$config_dir/batrc" "$HOME/.batrc"
ln -sf "$config_dir/ripgreprc" "$HOME/.ripgreprc"
ln -sf "$config_dir/pythonrc" "$HOME/.pythonrc"
echo "(Re)linked RC files"

ln -sfT "$config_dir/hammerspoon" "$HOME/.hammerspoon"

mkdir -p "$HOME/.data/zoxide"

# folders
ln -sfT "$cwd/zsh" "$HOME/.zsh"

# ---- XDG_CONFIG_HOME ----
stow --target="$xdg_dir" $xdg_source_dir

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
