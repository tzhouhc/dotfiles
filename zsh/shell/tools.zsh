# For configuring hooks from various installed tools

# zoxide
if type zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  # however, we'd rather use `z` as alias for `smart_cd`
  alias z=smart_cd
fi

# oh-my-posh prompt
if type oh-my-posh >/dev/null 2>&1; then
  if [[ $FALLBACK_MODE != '' ]]; then
    eval "$(oh-my-posh init zsh --config $XDG_CONFIG_HOME/oh-my-posh/fallback_prompt.json)"
  else
    eval "$(oh-my-posh init zsh --config $XDG_CONFIG_HOME/oh-my-posh/prompt.json)"
  fi
elif type starship &>/dev/null; then
  # starship prompt (no transient prompt)
  eval "$(starship init zsh)"
else
  export PS1='%F{blue}%~ %(?.%F{green}.%F{red})%#%f '
fi

# zgen plugins
# load early so that local changes remain in effect
source "$HOME/.zgen/zgen.zsh"
source "$ZSH_HOME/shell/zgen.zsh"

# atuin (shell history db)
eval "$(atuin init zsh --disable-up-arrow)"

# direnv (automatically run commands for certain directories)
eval "$(direnv hook zsh)"

# navi shell widget (so that it doesn't run immediately, allowing editing)
eval "$(navi widget zsh)"

if [[ -d "$(brew --prefix)/Caskroom/google-cloud-sdk" ]]; then
  source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi
