# ====================
# Environemental Vars
# ====================
# User configuration
export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export TERM=xterm-256color
export XDG_CONFIG_HOME="$HOME/.config"
export VIM_HOME="$XDG_CONFIG_HOME/nvim"
export MYVIMRC="$VIM_HOME/init.lua"
export COPY_FILE="$HOME/.copy"
export EDITOR=nvim
export GIT_EDITOR=nvim
export P4EDITOR=nvim
export P4DIFF=delta
export G4MULTIDIFF=0
if type bat >/dev/null 2>&1; then
  PREVIEWER=bat
else
  PREVIEWER=less
fi
export BAT_CONFIG_PATH="$HOME/.batrc"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# always skip existing when setting folder icons
export SET_ICON_SKIP_EXISTING=1

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
export LESS='--ignore-case --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=2 --no-init --window=-4 -j.5'
export HOMEBREW_NO_AUTO_UPDATE=1
export _ZO_DATA_DIR="$HOME/.data/zoxide"

# run if 'navi' exists on path
if type navi >/dev/null 2>&1; then
  export NAVI_PATH=$HOME/.dotfiles/lib/navi:$HOME/.local/share/navi
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

# also find symlinks
export FZF_DEFAULT_COMMAND='fd --type f --type l --hidden'
export FZF_DEFAULT_OPTS="--height 40% --reverse"
export FZF_CTRL_T_COMMAND=
export FZF_ALT_C_COMMAND=

if [[ $IS_PERSONAL_COMPUTER == 'true' ]]; then
  export CRITICAL_ROLE_PATH="/Users/tingzhou/Documents/Critical Role/CR FULL/tsv_transcripts"
  export ANDROID_HOME=~/Library/Android/sdk
  export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools
  export ANDROID_AVD_HOME=~/.android/avd
fi
