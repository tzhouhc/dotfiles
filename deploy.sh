#!/bin/bash
# the script is ideally completely idempotent

# oh-my-zsh
if ! [ -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
# zgen
if ! [ -e "$HOME/.zgen" ]; then
  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi

# current script location
cwd="$(dirname "$0")"
cwd="$(cd $cwd; pwd)"

# link config files
ln -sf "$cwd/zshrc" "$HOME/.zshrc"
ln -sf "$cwd/gitconfig" "$HOME/.gitconfig"
ln -sf "$cwd/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$cwd/ctags" "$HOME/.ctags"
# folders
ln -sf "$cwd/zsh" "$HOME/.zsh"
ln -sf "$cwd/vim" "$HOME/.vim"
rm -f "$cwd/zsh/zsh"
rm -f "$cwd/vim/vim"

# setup nvim setup
mkdir -p ~/.config/nvim
if ! [ -e "$HOME/.config/nvim/init.vim" ]; then
    cat <<EOF > ~/.config/nvim/init.vim
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vim/vimrc
EOF
fi

# install plugs for nvim
nvim +'PlugInstall --sync' +qa 2> /dev/null
