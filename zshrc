# If you come from bash you might have to change your $PATH.

# am I in google land
if [ -d '/google' ]; then
  is_google=true
else
  is_google=false
fi

# tmux settings
if [ -z "$TMUX" ]; then
  export PATH=$HOME/.rbenv/versions/2.5.1/bin:$HOME/local/bin:/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/TeX/texbin:/Library/Frameworks/Mono.framework/Versions/Current/Commands:$HOME/.fzf/bin:/usr/local/Cellar/node/12.9.0/bin:$PATH
  export PATH=$HOME/go/bin/:$HOME/.local/bin:$PATH
  tmux attach
fi

# read convenient short hands
source ~/.zsh/zsh_aliases

# read slightly longer 'shorthands'
source ~/.zsh/zsh_functions

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

setopt prompt_subst  # enable command substitution (and otheR expansions) in PROMPT
PROMPT='$(google3_prompt_info)$(g_prompt)%f %# '  # %f for stopping the foreground color
RPROMPT='$(r_prompt_info)'

# ========= Optional... options ============
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

ZSH_CUSTOM=$ZSH/custom
# installing plugins if not present
if ! [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting 2>&1 > /dev/null
fi
if ! [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions 2>&1 > /dev/null
fi
if ! [ -d "$ZSH_CUSTOM/plugins/zshmarks" ]; then
  git clone https://github.com/jocelynmallon/zshmarks.git $ZSH_CUSTOM/plugins/zshmarks 2>&1 > /dev/null
fi
if ! [ -d "$ZSH_CUSTOM/plugins/colored-man-pages" ]; then
  git clone https://github.com/ael-code/zsh-colored-man-pages.git $ZSH_CUSTOM/plugins/colored-man-pages 2>&1 > /dev/null
fi

plugins=(git zsh-syntax-highlighting zshmarks zsh-autosuggestions colored-man-pages)

if type "hg" > /dev/null; then
  plugins+=(mercurial)
fi
if type "brew" > /dev/null; then
  plugins+=(brew)
fi

source $ZSH/oh-my-zsh.sh

# User configuration
export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# exported vars
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
export TERM=xterm-256color
export MYVIMRC='~/.vim/vimrc'
export EDITOR=nvim
export G4MULTIDIFF=1
export P4DIFF='p4diff'
export TEXMFHOME=/Users/tingzhou/.texmf
export PYTHONSTARTUP=/Users/tingzhou/.pythonrc
export LESS=-R
export HOMEBREW_NO_AUTO_UPDATE=1

# up/down key for history search
bindkey -e
bindkey '[A' history-beginning-search-backward
bindkey '[B' history-beginning-search-forward

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# some google stuff
if $is_google; then
  source /etc/bash_completion.d/g4d
fi
