#!/bin/bash
set -e

# setup installation environment to be consistent
this_path="$(realpath "$0")"
cwd=$(dirname "${this_path}")
green="\033[0;32m"
reset="\033[0m"
cd "$cwd"

# make sure paths are set even if the corresponding binaries aren't installed
# yet; should be compatible with bash
source "$HOME/.zsh/env/path.zsh"

setup_echo() {
    printf "%b[SETUP]%b %s\n" "$green" "$reset" "$*"
}

if [[ $XDG_CONFIG_HOME == '' ]]; then
  setup_echo "No XDG_CONFIG_HOME set. Please verify you are running zsh."
  exit 1
fi

# --- Modes ---
# base -- just common commandline tools and shell improvements
# dev -- development tools
# full -- GUI tools, private stuff
#
declare -A COMPONENT_MODES=(
  [homebrew]="base dev full"
  [neovim]="base dev full"
  [rust_tools]="base dev full"
  [zellij_tools]="base dev full"

  [python_pkgs]="dev full"
  [creds]="dev full"
  [dev_setup]="dev full"
  [init]="dev full"

  [gui]="full"
  [private]="full"
  [rime]="full"
)

MODE="${1:-ask}"

confirm() {
  # Usage: confirm "Question?"
  local response
  printf "%b[SETUP]%b " "$green" "$reset"
  read -r -p "${1} [y/n]: " response
  [[ $response == "y" || $response == "Y" ]]
}

should_install() {
  local name="$1"
  if [[ "$MODE" == "ask" ]]; then
    confirm "Install/setup $name?"
  else
    [[ " ${COMPONENT_MODES[$name]} " =~ $MODE ]]
  fi
}

# install OS-dependent specific items
if uname -a | grep -i linux > /dev/null; then
  if type apt-get >/dev/null 2>&1; then
    sudo "$cwd"/install/apt.sh
  elif type apk >/dev/null 2>&1; then
    sudo "$cwd"/install/other/apk.sh
  elif type dnf >/dev/null 2>&1; then
    sudo "$cwd"/install/dnf.sh
  elif type yum >/dev/null 2>&1; then
    sudo "$cwd"/install/other/yum.sh
  elif type pacman >/dev/null 2>&1; then
    sudo "$cwd"/install/other/pacman.sh
  else
    setup_echo "Unknown OS, some software installation incomplete."
  fi
fi

# fzf
if ! [ -d "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  yes 'n' | ~/.fzf/install  # download only
  setup_echo "Installed FZF"
else
  setup_echo "FZF already present."
fi

# zinit -- this should actually be automatic once zsh and dotfiles are setup
# pre
if ! [[ -d "$HOME/.local/share/zinit" ]]; then
  NO_INPUT=1 NO_ANNEXES=1 bash -c \
    "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
else
  setup_echo "Zinit already present."
fi

# make zoxide database dir
mkdir -p "$HOME/.data/zoxide"

# tpm
if ! [ -d "$XDG_CONFIG_HOME/tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$XDG_CONFIG_HOME/tmux/plugins/tpm"
  setup_echo "Installing TPM."
else
  setup_echo "TPM already installed."
fi

# homebrew
if ! type brew &>/dev/null; then
  # install homebrew using just gcc and build-essentials
  if should_install homebrew "Install homebrew and related?"; then
    "$cwd"/install/brew.sh
  fi
fi

# Update path to enable pip.sh?
if uname -a | grep -i darwin > /dev/null; then
  export BREW_HOME=/opt/homebrew
else
  export BREW_HOME=/home/linuxbrew/.linuxbrew
fi
export PATH=$BREW_HOME/bin:$PATH

# with cargo installed, tools like bob should all become available for
# subsequent use.
if ! type nvim &>/dev/null; then
  if should_install neovim "Install neovim?"; then
    "$cwd"/install/core/nvim.sh
  fi

  pushd "$HOME/.config/nvim"
  git checkout main
  popd
else
  setup_echo "Neovim already setup."
fi


# try to acquire latest binaries after installations
hash -r

# assumes python is already present and up-to-date
if should_install python_pkgs "Install python packages?"; then
  "$cwd"/install/pip.sh
fi

# install rust tools
if ! type cargo &>/dev/null; then
  if should_install rust_tools "Install rust tools?"; then
    "$cwd"/install/cargo.sh
  fi
else
  setup_echo "rust already present."
fi

# install zellij tools
if ! type zjframes.wasm &>/dev/null; then
  if should_install zellij_tools "Install zellij tools? (does not require zellij installed)"; then
    "$cwd"/install/zellij.sh
  fi
else
  setup_echo "zellij tools already present."
fi

# setup private data repo
if [[ -d "$HOME/.private.git" ]]; then
  setup_echo "Private repo already setup."
else
  if should_install private "Setup Private files repo?"; then
    git clone --bare git@github.com:tzhouhc/private.git "$HOME/.private.git"
    git --git-dir="$HOME/.private.git" --work-tree="$HOME" checkout -f
    "$HOME/.private/setup.sh"
  fi
fi

# setup squirrel config
if uname -a | grep -i darwin &>/dev/null; then
  if should_install rime "Setup Rime input?"; then
    "$cwd"/lib/rime/setup
  fi
fi

# setup for development in addition to just regular usage
if should_install dev_setup "Setup for development?"; then
  "$cwd"/install/dev/brew.sh
  "$cwd"/install/dev/cargo.sh
  # uv for python package management
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

if should_install gui "Setup GUI applications and fonts?"; then
  "$cwd"/install/gui/brew.sh
fi

# ------ manual interaction ------
# The following section requires some human interaction
setup_echo "All automation completed -- Now onto manual configuration:"

# setup LLM service credentials
if should_install creds "Setup Credentials?"; then
  "$cwd"/install/creds.sh
fi

# initialization for some tooling
if should_install init "Perform tooling first-time setup."; then
  setup_echo "Setting up other tools:"
  "$cwd/install/init.sh"
fi

# ensure user shell for subsequent logins
current_shell="${SHELL##*/}"
if [[ "$current_shell" != zsh* ]]; then
  which zsh | sudo tee -a /etc/shells
  setup_echo "Updating user login shell:"
  chsh -s "$(which zsh)"
fi
