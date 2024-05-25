# Establishes the locations of various executables.
#
# Can be sourced as a standalone file for effect.

# Base paths
export PATH=''
export PATH=/bin:$PATH
export PATH=/sbin:$PATH
export PATH=/usr/bin:$PATH
export PATH=/usr/local/sbin:/usr/local/bin:$PATH
export PATH=/usr/sbin:$PATH

# os-dependent brew home
if uname -a | grep -i darwin > /dev/null; then
  export BREW_HOME=/opt/homebrew
else
  export BREW_HOME=/home/linuxbrew/.linuxbrew
fi

export PATH=$BREW_HOME/bin:$PATH

# ---- HOME paths ----
# rust based tools
export PATH=$HOME/.cargo/bin:$PATH
# custom scripts
export PATH=$HOME/.local/bin:$PATH
# portable scripts
export PATH=$HOME/.dotfiles/bin:$PATH

# NEOVIM via bob-nvim
export PATH=$HOME/.local/share/bob/nvim-bin:$PATH

# fzf
export PATH=$HOME/.fzf/bin:$PATH
# gnubin -- ls without color AND with stupid ass quotes
export PATH=/$BREW_HOME/opt/grep/libexec/gnubin:$PATH
export PATH=/$BREW_HOME/opt/coreutils/libexec/gnubin:$PATH
export PATH=/$BREW_HOME/opt/openjdk/bin:$PATH

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

export LDFLAGS="-L/$BREW_HOME/opt/ruby/lib"
export CPPFLAGS="-I/$BREW_HOME/opt/ruby/include"
export CPPFLAGS="-I/$BREW_HOME/opt/openjdk/include"
export PKG_CONFIG_PATH="/$BREW_HOME/opt/ruby/lib/pkgconfig"
