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
