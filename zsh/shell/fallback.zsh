# If Nerdfont or Powerline are not available, revert some of the visual
# improvements for a functional UI (e.g. SSH-ing from tablets).

# Use version with reduced nerd font glyph usage
# Not relevant -- we use oh-my-posh now
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship_fallback.toml"

# No icon eza lists
if type eza >/dev/null 2>&1; then
  # do not print icons -- we don't support them
  alias ls='eza --icons=never --no-quotes --group-directories-first'
else
  if [[ -z $(ls --version 2>/dev/null | grep gnu) ]]; then
    # GNU
    alias ls='ls -G'
    # BSD
  else
    alias ls='ls -N --color -h --sort=extension --group-directories-first -v'
  fi
fi
