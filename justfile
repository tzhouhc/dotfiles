# Installation is irrelevant since just is not installed yet.

# deploy all symlinks from the dotfiles storage
deploy:
  ./deploy.sh

# edit starship config
starship:
  nvim xdg_configs/starship.toml

# edit atuin config
atuin:
  nvim xdg_configs/atuin/config.toml

# edit justfile
justfile:
  nvim justfile
