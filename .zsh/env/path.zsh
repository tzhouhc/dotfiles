# Establishes the locations of various executables.
#
# Can be sourced as a standalone file for effect.

# Base paths
export PATH=''
export PATH=/bin:$PATH
export PATH=/sbin:$PATH
export PATH=/usr/bin:$PATH
export PATH=/usr/games:$PATH
export PATH=/usr/local/sbin:/usr/local/bin:$PATH
export PATH=/usr/local/go/bin:$PATH
export PATH=/usr/sbin:$PATH

# os-dependent brew home
if uname -a | grep -i darwin > /dev/null; then
  export BREW_HOME=/opt/homebrew
else
  export BREW_HOME=/home/linuxbrew/.linuxbrew
fi

export PATH=/snap/bin:$PATH

export PATH=$BREW_HOME/bin:$PATH

# ---- HOME paths ----
# rust based tools
export PATH=$HOME/.cargo/bin:$PATH
# go based tools
export PATH=$HOME/.go/bin:$PATH
# custom scripts
export PATH=$HOME/.local/bin:$PATH
# portable scripts
export PATH=$HOME/.dotfiles/bin:$PATH
# floaterm
export PATH=$HOME/.local/share/nvim/lazy/vim-floaterm/bin:$PATH

# NEOVIM via bob-nvim
export PATH=$HOME/.local/share/bob/nvim-bin:$PATH

# fzf
export PATH=$HOME/.fzf/bin:$PATH
# gnubin -- ls without color AND with stupid ass quotes
export PATH=/$BREW_HOME/opt/grep/libexec/gnubin:$PATH
export PATH=/$BREW_HOME/opt/coreutils/libexec/gnubin:$PATH
export PATH=/$BREW_HOME/opt/openjdk/bin:$PATH
export PATH=$BREW_HOME/opt/make/libexec/gnubin:$PATH

# dotnet
export PATH=/usr/local/share/dotnet/x64/:$PATH
if uname -a | grep -i darwin > /dev/null; then
  # ruby
  export PATH=/$BREW_HOME/opt/ruby/bin:$PATH
  # latex
  export PATH=/Library/TeX/texbin/:$PATH
  # wezterm
  export PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
  # hammerspoon
  export PATH="$PATH:$HOME/.hammerspoon/bin"
fi

export LIBRARY_PATH=$LIBRARY_PATH:/opt/homebrew/opt/openssl@3/lib/
export LDFLAGS="-L/$BREW_HOME/opt/ruby/lib"
export CPPFLAGS="-I/$BREW_HOME/opt/ruby/include"
export CPPFLAGS="-I/$BREW_HOME/opt/openjdk/include"
export PKG_CONFIG_PATH="/$BREW_HOME/opt/ruby/lib/pkgconfig"
export DYLD_LIBRARY_PATH="$BREW_HOME/lib:$DYLD_LIBRARY_PATH"

if [[ -d "$HOME/.cache/lm-studio/bin" ]]; then
  export PATH=$PATH:$HOME/.cache/lm-studio/bin
fi
if [[ -d "$HOME/.nvim" ]]; then
  export PATH=$HOME/.nvim/bin:$PATH
fi
if [[ -d '/Applications/Sublime Text.app/' ]]; then
  export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
fi
