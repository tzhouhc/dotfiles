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
# If using gnu version, disable zsh's ls alias and use my own
if ls --color -d . >/dev/null 2>&1; then
    DISABLE_LS_COLORS="true"
fi

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
HIST_STAMPS="yyyy/mm/dd"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Determines what is a "word" for the purpose of backward-kill-word
WORDCHARS=" *?_-.[]~=&;!#$%^(){}<>/"
autoload -Uz select-word-style
select-word-style normal
zstyle ':zle:*' word-style unspecified

setopt prompt_subst  # enable command substitution (and otheR expansions) in PROMPT

setopt EXTENDED_HISTORY
# setopt HIST_IGNORE_ALL_DUPS
# too aggressive
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

set -o magicequalsubst

# recall recent dirs
set -o autopushd

setopt RE_MATCH_PCRE

# explicitly set TMPDIR on macos; workaround for wezterm issue?
if uname -a | grep -i darwin &>/dev/null; then
  export TMPDIR=$(getconf DARWIN_USER_TEMP_DIR)
fi
