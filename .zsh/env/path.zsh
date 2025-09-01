# Establishes the locations of various executables.
#
# Can be sourced as a standalone file for effect.

# os-dependent brew home
if uname -a | grep -i darwin > /dev/null; then
  export BREW_HOME=/opt/homebrew
else
  export BREW_HOME=/home/linuxbrew/.linuxbrew
fi

# PATH components in priority order (highest to lowest)
# Earlier entries in the array have higher priority.
#
# Script will automatically remove nonexistent dirs.
path_components=(
  # GNU tools (highest priority)
  "$BREW_HOME/opt/coreutils/libexec/gnubin"
  # Java
  "$BREW_HOME/opt/openjdk/bin"
  # Ruby
  "$BREW_HOME/opt/ruby/bin"
  # Latex
  "/Library/TeX/texbin"

  # FZF
  "$HOME/.fzf/bin"

  # NEOVIM (bob-nvim takes precedence over binary release)
  "$HOME/.local/share/bob/nvim-bin"
  "$HOME/.local/nvim/bin"

  # HOME paths - custom tools and scripts
  "$HOME/.dotfiles/bin"
  "$HOME/.dotfiles/sbin"
  "$HOME/.local/bin"
  "$HOME/.go/bin"
  "$HOME/.cargo/bin"

  # Brew
  "$BREW_HOME/bin"
  "$BREW_HOME/sbin"

  # Snap
  "/snap/bin"

  # wezterm
  "/Applications/WezTerm.app/Contents/MacOS"
  # hammerspoon
  "$HOME/.hammerspoon/bin"
  # dotnet
  "/usr/local/share/dotnet/x64"
  # lm-studio
  "$HOME/.cache/lm-studio/bin"
  # sublime
  "/Applications/Sublime Text.app/Contents/SharedSupport/bin"

  # System paths
  "/usr/sbin"
  "/usr/local/go/bin"
  "/usr/local/sbin"
  "/usr/local/bin"
  "/usr/games"
  "/usr/bin"
  "/sbin"
  "/bin"
)

# Build PATH from the array
export PATH=""
for path_dir in "${path_components[@]}"; do
  if [[ -d "$path_dir" ]]; then
    export PATH="$PATH:$path_dir"
  fi
done

export LIBRARY_PATH=$LIBRARY_PATH:/opt/homebrew/opt/openssl@3/lib/
export LDFLAGS="-L/$BREW_HOME/opt/ruby/lib"
export CPPFLAGS="-I/$BREW_HOME/opt/ruby/include"
export CPPFLAGS="-I/$BREW_HOME/opt/openjdk/include"
export PKG_CONFIG_PATH="/$BREW_HOME/opt/ruby/lib/pkgconfig"
export DYLD_LIBRARY_PATH="$BREW_HOME/lib:$DYLD_LIBRARY_PATH"

# export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
