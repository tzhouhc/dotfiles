#!/bin/bash
# the script is ideally completely idempotent

if ! [ -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# current script location
cwd="$(dirname "$0")"
cwd="$(cd $cwd; pwd)"

# link config files
ln -sf "$cwd/zshrc" "$HOME/.zshrc"
ln -sf "$cwd/zsh" "$HOME/.zsh"
ln -sf "$cwd/gitconfig" "$HOME/.gitconfig"
ln -sf "$cwd/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$cwd/ctags" "$HOME/.ctags"
ln -sf "$cwd/vim" "$HOME/.vim"

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
