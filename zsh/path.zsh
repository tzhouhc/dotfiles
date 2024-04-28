# Base paths
export PATH=''
export PATH=/bin:$PATH
export PATH=/sbin:$PATH
export PATH=/usr/bin:$PATH
export PATH=/usr/local/sbin:/usr/local/bin:$PATH
export PATH=/usr/sbin:$PATH
export PATH=/opt/homebrew/bin:$PATH

# HOME paths
export PATH=$HOME/local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.dotfiles/bin:$PATH
# fzf
export PATH=$HOME/.fzf/bin:$PATH
# gnubin -- ls without color AND with stupid ass quotes
export PATH=/opt/homebrew/opt/grep/libexec/gnubin:$PATH
export PATH=/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH
export PATH=/opt/homebrew/opt/openjdk/bin:$PATH

if [[ $IS_PERSONAL_COMPUTER == "true" ]]; then
  # ruby
  export PATH=/opt/homebrew/opt/ruby/bin:$PATH
  export PATH=/opt/homebrew/lib/ruby/gems/3.0.0/bin:$PATH
  # dotnet
  export PATH=/usr/local/share/dotnet/x64/:$PATH
  # latex
  export PATH=/Library/TeX/texbin/:$PATH
else
  export PATH=$PATH:/google/bin/releases/editor-devtools
fi

export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"
