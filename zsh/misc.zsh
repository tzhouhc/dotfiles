# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# to prevent p10k from trying to rerun the wizard
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
POWERLEVEL9K_IGNORE_TERM_COLORS=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  short_pwd
  dir_writable
  git_simple
  # vcs
)
# weird symbol issue on gnome-terminal on right edge
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(small_status)
