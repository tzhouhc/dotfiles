# Installation is irrelevant since just is not installed yet.

# deploy all symlinks from the dotfiles storage
deploy:
  ./deploy.sh

# install optional tools
install-optional:
  ./install/cargo_optional.sh

# edit justfile
justfile:
  nvim justfile

# refresh bat cached binaries
refresh-bat:
  bat cache --build
