# ====================
# Environemental Vars
# ====================
# User configuration
export MANPATH="/usr/local/man:$MANPATH"
export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export TERM=xterm-256color
export MYVIMRC='~/.vim/vimrc'
export COPY_FILE="$HOME/.copy"
export EDITOR=supervim
export GIT_EDITOR=nvim
export P4EDITOR=nvim
if type bat >/dev/null 2>&1; then
  PREVIEWER=bat
else
  PREVIEWER=less
fi
export BAT_CONFIG_PATH="$HOME/.batrc"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# enable dir-context-aware history tool
if [[ $DIR_AWARE_HISTFILE != '' && ! -f $DIR_AWARE_HISTFILE ]]; then
  touch $DIR_AWARE_HISTFILE
fi
if [[ $DIR_HISTFILE != '' && ! -f $DIR_HISTFILE ]]; then
  touch $DIR_HISTFILE
fi

export TEXMFHOME="$HOME/.texmf"
export PYTHONSTARTUP="$HOME/.pythonrc"
export RUBYLIB="$HOME/local/lib/ruby"
export LESS='--ignore-case --quit-if-one-screen --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=2 --no-init --window=-4'
export HOMEBREW_NO_AUTO_UPDATE=1

# run if 'navi' exists on path
if type navi >/dev/null 2>&1; then
  export NAVI_PATH=$HOME/.zsh/navi:$(readlink -f $(which navi) | sed 's/bin\/navi/libexec\/cheats/')
fi

if [[ -a $HOME/.dotfiles/visuals/lscolors ]]; then
  export LS_COLORS="$(cat $HOME/.dotfiles/visuals/lscolors)"
fi

# /usr/local/share/nvim/runtime/macros/less.sh
export PAGER="less"
export MANPAGER="less"

# export QUOTING_STYLE=literal

# export LDFLAGS="-L/usr/local/opt/llvm/lib"
# export CPPFLAGS="-I/usr/local/opt/llvm/include"

export FZF_DEFAULT_COMMAND='fd --type f --hidden'
export FZF_DEFAULT_OPTS="--height 40% --reverse"

if [[ $IS_GOOGLE == 'true' ]]; then
  export VIM_USE_CIDER_STAGING=1
  export VIM_USE_SEMANTIC_HIGHLIGHTING=1
fi

if [[ $IS_PERSONAL_COMPUTER == 'true' ]]; then
  export CRITICAL_ROLE_PATH="/Users/tingzhou/Documents/Critical Role/Campaign 1"
fi
