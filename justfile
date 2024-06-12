# Installation is irrelevant for new setups, but can still be used for
# reinstallations -- they _should_ all be idempotent.

# deploy all symlinks from the dotfiles storage
deploy:
  ./deploy.sh

# install main tools
install:
  ./install.sh

# install optional tools
install-optional:
  ./install/cargo_optional.sh

# edit justfile
justfile:
  nvim justfile

# refresh bat cached binaries
refresh-bat:
  bat cache --build

# switch to lazyvim instead of current nvim setup
use-lazyvim:
  #!/usr/bin/env zsh
  set -euxo pipefail
  mv ~/.config/nvim{,.bak}
  mv ~/.local/share/nvim{,.bak}
  mv ~/.local/state/nvim{,.bak}
  mv ~/.cache/nvim{,.bak}
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git

# switch back to my vim setup
use-myvim:
  #!/usr/bin/env zsh
  set -euxo pipefail
  rm -rf ~/.config/nvim
  rm -rf ~/.local/share/nvim
  rm -rf ~/.local/state/nvim
  rm -rf ~/.cache/nvim

  mv ~/.config/nvim{.bak,}
  mv ~/.local/share/nvim{.bak,}
  mv ~/.local/state/nvim{.bak,}
  mv ~/.cache/nvim{.bak,}
