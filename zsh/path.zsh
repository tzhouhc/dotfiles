# Base paths
export PATH=''
export PATH=/bin:$PATH
export PATH=/sbin:$PATH
export PATH=/usr/bin:$PATH
export PATH=/usr/local/sbin:/usr/local/bin:$PATH
export PATH=/usr/sbin:$PATH

# HOME paths
export PATH=$HOME/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.dotfiles/bin:$PATH
# fzf
export PATH=$HOME/.fzf/bin:$PATH
# gnubin -- ls without color AND with stupid ass quotes
export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH

if [[ $IS_PERSONAL_COMPUTER == "true" ]]; then
  # ruby
  export PATH=$HOME/.rbenv/versions/2.5.1/bin:$PATH
  # go
  export PATH=$HOME/go/bin/:$PATH
  # rust
  export PATH=$HOME/.cargo/bin:$PATH

  # tex
  export PATH=/Library/TeX/texbin:$PATH
  # mono
  export PATH=/Library/Frameworks/Mono.framework/Versions/Current/Commands:$PATH
  # node
  export PATH=/usr/local/Cellar/node/12.9.0/bin:$PATH
  # llvm
  # export PATH="/usr/local/opt/llvm/bin:$PATH
fi