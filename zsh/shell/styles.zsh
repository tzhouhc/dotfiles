# Z-styles

# ------------
# Fzf-tab options
# ------------

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no

# Smart preview
zstyle ':fzf-tab:complete:*:*' fzf-preview 'small_preview $realpath'
# give preview some space
zstyle ':fzf-tab:*' fzf-min-height 12

zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# apply to all command
zstyle ':fzf-tab:*' popup-min-size 80 8

# - remove preview border
# NOTE: Reloading zsh is insufficient to fully apply options like heights; for
# height, tmux itself needs to be reloaded for the config to take effect.
zstyle ':fzf-tab:*' fzf-flags --preview-window=noborder --height=100%

# -- keybinds

# space for multi-select
zstyle ':fzf-tab:*' fzf-bindings 'space:toggle'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
