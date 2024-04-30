# For configuring hooks from various installed tools

# zoxide
if type zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# starship prompt
if type starship >/dev/null 2>&1; then
  if [[ "$FALLBACK_MODE" == 'true' ]]; then
    # has reduced special character usage
    export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship_fallback.toml"
  fi
  # defaults to the standard starship.toml
  eval "$(starship init zsh)"
else
  export PS1='%F{blue}%~ %(?.%F{green}.%F{red})%#%f '
fi

# zgen plugins
# load early so that local changes remain in effect
source "$HOME/.zgen/zgen.zsh"
source "$ZSH_SETUP/zgen.zsh"

# atuin (shell history db)
eval "$(atuin init zsh --disable-up-arrow)"
