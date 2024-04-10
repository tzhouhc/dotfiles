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

# potentially the one introduced by oh-my-zsh
if [ -e "$HOME/.zshrc" ]; then
  rm ~/.zshrc
fi

# link config files
ln -sf "$cwd/zshrc" "$HOME/.zshrc"
ln -sf "$config_dir/gitconfig" "$HOME/.gitconfig"
ln -sf "$config_dir/gitignore" "$HOME/.gitignore"
ln -sf "$config_dir/batrc" "$HOME/.batrc"
ln -sf "$config_dir/ripgreprc" "$HOME/.ripgreprc"
mkdir -p "~/.configs/fd"
mkdir -p "~/.data/zoxide"
ln -sf "$config_dir/fdignore" "~/.configs/fd/ignore"
ln -sf "$config_dir/pythonrc" "$HOME/.pythonrc"
ln -sf "$config_dir/tmux.conf" "$HOME/.tmux.conf"
# TODO: fix tpm install
ln -sf "$config_dir/ctags" "$HOME/.ctags"
# folders
ln -sf "$cwd/zsh" "$HOME/.zsh"
ln -sf "$cwd/vim" "$HOME/.vim"
rm -f "$cwd/zsh/zsh"
rm -f "$cwd/vim/vim"

# setup nvim setup
mkdir -p ~/.config/nvim
if ! [ -e "~/.config/nvim/init.lua" ]; then
  ln -sf "$HOME/.vim" "$HOME/.config/nvim"
fi

# setting up variation software
if type fdfind 2>/dev/null; then
  ln -sf $(which fdfind) "$HOME/.local/bin/fd"
fi

# install plugs for nvim
# headless for that quiet installation
nvim --headless +'PlugInstall --sync' +qa 2> /dev/null

echo "successfully deployed dotfiles."
