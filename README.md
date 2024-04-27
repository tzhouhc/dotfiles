# Dotfiles

Normal initialization:

```sh
git clone --recurse-submodules git@github.com:tzhouhc/dotfiles.git ~/.dotfiles
~/.dotfiles/deploy.sh
```

If cloned without `--recurse-submodule`:

```sh
git submodule update --init --recursive
```

# Install tools

If additional tooling is required, run the `install.sh` script.

## Neovim

[Installation Guide](https://github.com/neovim/neovim/blob/master/INSTALL.md)

[macOS Download](https://github.com/neovim/neovim/releases/latest/download/nvim-macos.tar.gz)

```sh
xattr -c ./nvim-macos-arm64.tar.gz
tar xzvf nvim-macos-arm64.tar.gz  # creating a new dir with all the stuff
rsync -a nvim-macos/ $HOME/.local/  # note the ending slash on both dirs
```

[linux Download](https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz)

Similar commands apply.

```sh
xattr -c ./nvim-linux64.tar.gz
tar xzvf nvim-linux64.tar.gz  # creating a new dir with all the stuff
rsync -a nvim-linux/ $HOME/.local/  # note the ending slash on both dirs
```

# Requirements

Latest zsh configurations require `Nerdfont` support.
