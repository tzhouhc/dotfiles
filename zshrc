ZSH_SETUP="$HOME/.zsh"

# If you come from bash you might have to change your $PATH.
source "$ZSH_SETUP/path.sh"

# Now that PATH is set, check whether the coreutils on top of the list
# is BSD or GNU
if [[ -z $(ls --version | grep gnu) ]]; then
  export COREUTILS_VER=BSD
else
  export COREUTILS_VER=GNU
fi

# tmux settings
source "$ZSH_SETUP/tmux.sh"

# stuff for googleland
source "$ZSH_SETUP/google.sh"

# read convenient short hands
source "$ZSH_SETUP/zsh_aliases"

# read slightly longer 'shorthands'
source "$ZSH_SETUP/zsh_functions"

# env vars
source "$ZSH_SETUP/env.sh"

# read custom completions
source "$ZSH_SETUP/zsh_completions"

source "$ZSH_SETUP/zsh_settings"

# zgen plugins
source "$HOME/.zgen/zgen.zsh"
source "$ZSH_SETUP/zgen.sh"

source "$ZSH_SETUP/keys.sh"

source "$ZSH_SETUP/misc.sh"

# DEPENDENCY LIST
# zsh
# tmux
# neovim
# fzf (handled)
# git
# bat -- for colorized preview of syntaxed files
