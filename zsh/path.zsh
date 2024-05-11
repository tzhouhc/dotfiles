# Base paths
export PATH=''
export PATH=/bin:$PATH
export PATH=/sbin:$PATH
export PATH=/usr/bin:$PATH
export PATH=/usr/local/sbin:/usr/local/bin:$PATH
export PATH=/usr/sbin:$PATH
export PATH=/opt/homebrew/bin:$PATH

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
export PATH=/opt/homebrew/opt/grep/libexec/gnubin:$PATH
export PATH=/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH
export PATH=/opt/homebrew/opt/openjdk/bin:$PATH

# dotnet
export PATH=/usr/local/share/dotnet/x64/:$PATH
if uname -a | grep -i darwin > /dev/null; then
  # ruby
  export PATH=/opt/homebrew/opt/ruby/bin:$PATH
  # latex
  export PATH=/Library/TeX/texbin/:$PATH
fi

export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"
