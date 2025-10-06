# Environemental Vars
#
# Can be sourced as a standalone file for effect, though less meaningful
# outside shell contexts.

export MANPATH="/usr/local/man:$MANPATH"

if type brew &>/dev/null; then
  # Homebrew
  if uname -a | grep -i darwin > /dev/null; then
    eval "$(brew shellenv)"
  else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi

# While in China, use TSU's homebrew mirrors:
if [[ $(date +%Z) == "CST" ]]; then
  export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
  export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
  export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
  export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
  export HOMEBREW_PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"
  # rust
  export RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup
  export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup
fi


# You may need to manually set your language environment
export LANG=en_US.UTF-8
export TERM=xterm-256color
export XDG_CONFIG_HOME="$HOME/.config"
export VIM_HOME="$XDG_CONFIG_HOME/nvim"
export MYVIMRC="$VIM_HOME/init.lua"
export EDITOR=nvim
# for when the editor can be called from within nvim itself
export CSCOPE_EDITOR=floatvim
export VISUAL=nvim
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

HISTFILE="$HOME/.zsh_history"
SAVEHIST=3000
# setting this value larger than the SAVEHIST size will give you the difference
# as a cushion for saving duplicated history events.
HISTSIZE=5000
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
export GOPATH="$HOME/.go"

export GH_USER="tzhouhc"

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

export FZF_DEFAULT_COMMAND='fd --type f --type l --hidden'
export FZF_CTRL_T_COMMAND=
export FZF_ALT_C_COMMAND=

# Various env-var based credentials
if type age &>/dev/null; then
  if [[ -f "$HOME/.ssh/id_ed25519" ]]; then
    ENC_KEY="$HOME/.ssh/id_ed25519"
  elif [[ -f "$HOME/.ssh/id_rsa" ]]; then
    ENC_KEY="$HOME/.ssh/id_rsa"
  fi

  if [[ -f "$HOME/.credentials/openai_key" ]]; then
    export OPENAI_API_KEY="$(/usr/bin/env age -d -i $ENC_KEY $HOME/.credentials/openai_key)"
  fi
  if [[ -f "$HOME/.credentials/openrouter_key" ]]; then
    export OPENROUTER_API_KEY="$(/usr/bin/env age -d -i $ENC_KEY $HOME/.credentials/openrouter_key)"
  fi
  if [[ -f "$HOME/.credentials/deepseek_key" ]]; then
    export DEEPSEEK_API_KEY="$(/usr/bin/env age -d -i $ENC_KEY $HOME/.credentials/deepseek_key)"
  fi
  if [[ -f "$HOME/.credentials/github_key" ]]; then
    export GH_TOKEN="$(/usr/bin/env age -d -i $ENC_KEY $HOME/.credentials/github_key)"
  fi
fi
# pay-respect
if [[ $OPENAI_API_KEY != '' ]]; then
  export _PR_AI_API_KEY=${OPENROUTER_API_KEY}
  export _PR_AI_URL="https://openrouter.ai/api/v1/chat/completions"
  export _PR_AI_MODEL="deepseek/deepseek-chat"
fi

# pnpm
export PNPM_HOME="/Users/tingzhou/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Macos Malloc and Libasan issue
if uname -a | grep -i darwin &>/dev/null; then
  export MallocNanoZone=0
fi
