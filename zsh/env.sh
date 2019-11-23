# ====================
# Environemental Vars
# ====================
# User configuration
export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export TERM=xterm-256color
export MYVIMRC='~/.vim/vimrc'
export EDITOR=nvim

export TEXMFHOME=$HOME/.texmf
export PYTHONSTARTUP=$HOME/.pythonrc
export RUBYLIB=$HOME/local/lib/ruby
export LESS=-R
export HOMEBREW_NO_AUTO_UPDATE=1
if [[ -e '/usr/share/nvim/runtime/macros/less.sh' ]]; then
  export PAGER="/usr/share/nvim/runtime/macros/less.sh"
fi
export MANPAGER="/usr/bin/less"

export QUOTING_STYLE=literal

