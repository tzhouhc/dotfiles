ZSH_SETUP="$HOME/.zsh"

# variables
source "$ZSH_SETUP/vars.zsh"

# If you come from bash you might have to change your $PATH.
source "$ZSH_SETUP/path.zsh"

# zgen plugins
# load early so that local changes remain in effect
source "$HOME/.zgen/zgen.zsh"
source "$ZSH_SETUP/zgen.zsh"

# Account for variable software options
source "$ZSH_SETUP/variations.zsh"

# tmux settings
if [[ "$NOTMUX" == 'true' ]]; then
else
  source "$ZSH_SETUP/tmux.zsh"
fi

# stuff for googleland
source "$ZSH_SETUP/google.zsh"

# read convenient short hands
source "$ZSH_SETUP/aliases.zsh"

# read fzf related tools
source "$ZSH_SETUP/fzf.zsh"

# read slightly longer 'shorthands'
source "$ZSH_SETUP/functions.zsh"

# env vars
source "$ZSH_SETUP/env.zsh"

# read custom completions
source "$ZSH_SETUP/completions.zsh"

# various basic zsh settings
source "$ZSH_SETUP/settings.zsh"

# key mappings
source "$ZSH_SETUP/keys.zsh"

# zoxide
if type zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi


# fzf
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

if [[ $NERDFONT == 'false' ]]; then
  if [[ $POWERLINE == 'false' ]]; then
    [[ -f ~/.zsh/p10k_base.zsh ]] && source ~/.zsh/p10k_base.zsh
  else
    [[ -f ~/.zsh/p10k_pl.zsh ]] && source ~/.zsh/p10k_pl.zsh
  fi
else
  # starship
  if type starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
  fi
  source "$ZSH_SETUP/misc.zsh"
fi
