# Base paths
export PATH=''
export PATH=/bin:$PATH
export PATH=/sbin:$PATH
export PATH=/usr/bin:$PATH
export PATH=/usr/local/sbin:/usr/local/bin:$PATH
export PATH=/usr/sbin:$PATH
export PATH=/opt/homebrew/bin:$PATH

# subl
export PATH=/Applications/Sublime\ Text.app/Contents/SharedSupport/bin:$PATH

# HOME paths
export PATH=$HOME/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.dotfiles/bin:$PATH
# fzf
export PATH=$HOME/.fzf/bin:$PATH
# gnubin -- ls without color AND with stupid ass quotes
export PATH=/opt/homebrew/opt/grep/libexec/gnubin:$PATH
export PATH=/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH

if [[ $IS_PERSONAL_COMPUTER == "true" ]]; then
  # ruby
  export PATH=/usr/local/opt/ruby/bin:$PATH
  # ruby gems
  export PATH=/usr/local/lib/ruby/gems/2.7.0/bin:$PATH
fi
