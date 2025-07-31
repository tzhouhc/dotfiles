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

if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# zinit plugins
# load early so that local changes remain in effect
source "$ZSH_HOME/shell/zinit.zsh"

# atuin (shell history db)
if type atuin &>/dev/null; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# direnv (automatically run commands for certain directories)
if type direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# navi shell widget (so that it doesn't run immediately, allowing editing)
if type navi &>/dev/null; then
  eval "$(navi widget zsh)"
fi

# When using google-cloud-sdk, uncomment
# if type brew &>/dev/null; then
#   if [[ -d "$(brew --prefix)/Caskroom/google-cloud-sdk" ]]; then
#     source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
#     source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
#   fi
# fi

if type pay-respects &>/dev/null; then
  eval "$(pay-respects zsh --alias)"
fi

if type rbenv &>/dev/null; then
  eval "$(rbenv init - --no-rehash zsh)"
fi
