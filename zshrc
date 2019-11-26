ZSH_SETUP="$HOME/.zsh"

# PROMPT_STYLE='lean'

# If you come from bash you might have to change your $PATH.
source "$ZSH_SETUP/path.sh"

# Account for variable software options
source "$ZSH_SETUP/variations.sh"

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

if [[ $PROMPT_STYLE == 'lean' ]]; then
  source "$ZSH_SETUP/alt_p10k.sh"
else
  source "$ZSH_SETUP/misc.sh"
fi
