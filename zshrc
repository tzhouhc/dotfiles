ZSH_SETUP="$HOME/.zsh"

source "$ZSH_SETUP/vars.zsh"

# PROMPT_STYLE='lean'

# If you come from bash you might have to change your $PATH.
source "$ZSH_SETUP/path.zsh"

# Account for variable software options
source "$ZSH_SETUP/variations.zsh"

# tmux settings
source "$ZSH_SETUP/tmux.zsh"

# stuff for googleland
source "$ZSH_SETUP/google.zsh"

# read convenient short hands
source "$ZSH_SETUP/aliases.zsh"

# read slightly longer 'shorthands'
source "$ZSH_SETUP/functions.zsh"

# env vars
source "$ZSH_SETUP/env.zsh"

# read custom completions
source "$ZSH_SETUP/completions.zsh"

source "$ZSH_SETUP/settings.zsh"

# zgen plugins
source "$HOME/.zgen/zgen.zsh"
source "$ZSH_SETUP/zgen.zsh"

source "$ZSH_SETUP/keys.zsh"

source "$ZSH_SETUP/misc.zsh"
