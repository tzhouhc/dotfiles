#!/usr/bin/env zsh

# First, run deploy.sh by itself. It assumes presence of stow, but otherwise should be
# able to run on a decently equipped host.

# zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# atuin
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

mkdir -p ~/Downloads

pushd ~/Downloads
# nvim
wget https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.tar.gz
mv nvim-linux-x86_64 ~/.nvim

# lazygit
wget https://github.com/jesseduffield/lazygit/releases/download/v0.45.2/lazygit_0.45.2_Linux_x86_64.tar.gz
tar xf lazygit_0.45.2_Linux_x86_64.tar.gz
mv lazygit ~/.local/bin
