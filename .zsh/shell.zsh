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

# some special zsh settings -- special handlers, etc
source "$SHELL_SCRIPTS_DIR/special.zsh"

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

# session multiplexer -- we prefer zellij but can also use tmux
# both scripts contain code to
# 1. avoid recursion
# 2. avoid each other
# 3. skip creation if NOTMUX is set or ~/.notmux exists.
if type zellij &>/dev/null; then
  source "$SHELL_SCRIPTS_DIR/zellij.zsh"
elif type tmux &>/dev/null; then
  source "$SHELL_SCRIPTS_DIR/tmux.zsh"
fi

# some items needs to run after tmux
source "$SHELL_SCRIPTS_DIR/post_tmux.zsh"

# health checkup
source "$SHELL_SCRIPTS_DIR/checkup.zsh"

# update checking
source "$SHELL_SCRIPTS_DIR/update.zsh"
