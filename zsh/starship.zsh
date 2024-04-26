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

