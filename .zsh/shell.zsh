#!/usr/bin/env zsh
# Contains additional setups and configurations that are only relavant in an
# interactive shell environment, such as completions, shortcuts, aliases, etc.

ZSH_HOME="$HOME/.zsh"
SHELL_SCRIPTS_DIR="$ZSH_HOME/shell"

# read custom completions for zsh
source "$SHELL_SCRIPTS_DIR/completions.zsh"

# zstyle settings
source "$SHELL_SCRIPTS_DIR/styles.zsh"

# various basic zsh settings
source "$SHELL_SCRIPTS_DIR/settings.zsh"

# key mappings in zsh
source "$SHELL_SCRIPTS_DIR/keys.zsh"

# read convenient short hands
# also ensures functions do _not_ see the aliases and get messed up logic
source "$SHELL_SCRIPTS_DIR/aliases.zsh"

# configuring tool hooks in zsh
# Cumulatively about 0.2s of load time
source "$SHELL_SCRIPTS_DIR/tools.zsh"

if [[ -n "$FALLBACK_MODE" ]]; then
  source "$SHELL_SCRIPTS_DIR/fallback.zsh"
fi

# optionally start up TMUX unless NOTMUX is set
source "$SHELL_SCRIPTS_DIR/tmux.zsh"

if type zellij &>/dev/null; then
  source "$SHELL_SCRIPTS_DIR/zellij.zsh"
fi

# some items needs to run after tmux
source "$SHELL_SCRIPTS_DIR/post_tmux.zsh"

# update checking
source "$SHELL_SCRIPTS_DIR/update.zsh"
