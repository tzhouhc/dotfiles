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

# read custom completions
source ~/.zsh/zsh_completions

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

setopt prompt_subst  # enable command substitution (and otheR expansions) in PROMPT
POWERLINE_PROMPT=1

if [ POWERLINE_PROMPT ]; then
  POWERLEVEL9K_IGNORE_TERM_COLORS=true
  POWERLEVEL9K_CUSTOM_RELATIVE_ROOT=relative_root
  POWERLEVEL9K_CUSTOM_RELATIVE_ROOT_BACKGROUND="red"
  POWERLEVEL9K_CUSTOM_RELATIVE_DEPTH=relative_depth
  POWERLEVEL9K_CUSTOM_RELATIVE_DEPTH_BACKGROUND="yellow"
  POWERLEVEL9K_CUSTOM_CURRENT_DIR=current_dir
  POWERLEVEL9K_CUSTOM_CURRENT_DIR_BACKGROUND="green"
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(custom_relative_root custom_relative_depth custom_current_dir dir_writable vcs)
  POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status)
else
  PROMPT='$(google3_prompt_info)$(git_prompt)%f '  # %f for stopping the foreground color
  RPROMPT='$(last_exitcode)'
fi

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

# ====================
# Zgen plugin management
# ====================
source "${HOME}/.zgen/zgen.zsh"
if ! zgen saved; then
  zgen oh-my-zsh

  # plugins
  zgen load bhilburn/powerlevel9k powerlevel9k
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-autosuggestions
  zgen load jocelynmallon/zshmarks
  zgen load ael-code/zsh-colored-man-pages
  zgen load rupa/z
  zgen load changyuheng/fz
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/pip
  if type "hg" > /dev/null; then
    zgen oh-my-zsh plugins/mercurial
  fi
  # save all to init script
  zgen save
fi

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
