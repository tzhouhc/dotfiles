#!/bin/bash
# the script is ideally completely idempotent

set -e

# fzf
if ! [ -d "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi
# zgen (handles zsh)
if ! [ -e "$HOME/.zgen" ]; then
  git clone https://github.com/tarjoilija/zgen.git ~/.zgen
fi
# tpm
if ! [ -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# current script location
cwd="$(dirname "$0")"
cwd="$(cd $cwd; pwd)"

config_dir="$cwd/configs"
# for XDG_CONFIG_HOME
xdg_dir="$HOME/.config"
mkdir -p $xdg_dir

# potentially the one introduced by oh-my-zsh
if [ -e "$HOME/.zshrc" ]; then
  rm ~/.zshrc
fi

# link config files
ln -sf "$cwd/zshrc" "$HOME/.zshrc"
ln -sf "$config_dir/batrc" "$HOME/.batrc"
ln -sf "$config_dir/ripgreprc" "$HOME/.ripgreprc"
ln -sf "$config_dir/pythonrc" "$HOME/.pythonrc"
ln -sf "$config_dir/hammerspoon" "$HOME/.hammerspoon"

mkdir -p "~/.data/zoxide"

# folders
ln -sfT "$cwd/zsh" "$HOME/.zsh"

# ---- XDG_CONFIG_HOME ----
# git
mkdir -p "$xdg_dir/git"
ln -sf "$config_dir/gitconfig" "$xdg_dir/git/config"
ln -sf "$config_dir/gitignore" "$xdg_dir/git/ignore"
ln -sf "$config_dir/kitty" "$xdg_dir/kitty"
ln -sf "$config_dir/gitignore" "$HOME/.gitignore"

# fd
mkdir -p "$xdg_dir/fd"
ln -sf "$config_dir/fdignore" "$xdg_dir/fd/ignore"

# tmux
mkdir -p "$xdg_dir/tmux"
ln -sf "$config_dir/tmux.conf" "$xdg_dir/tmux/tmux.conf"

# ctags
ln -sfT "$config_dir/ctags" "$xdg_dir/ctags"

# setup nvim setup
ln -sfT "$cwd/vim" "$xdg_dir/nvim"

# setting up variation software
if type fdfind 2>/dev/null; then
  ln -sf $(which fdfind) "$HOME/.local/bin/fd"
fi

echo "successfully deployed dotfiles."
