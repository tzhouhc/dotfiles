#!/usr/bin/env zsh

ZSH_HOME="$HOME/.zsh"

# read custom completions for zsh
source "$ZSH_HOME/completions.zsh"

# various basic zsh settings
source "$ZSH_HOME/settings.zsh"

# key mappings in zsh
source "$ZSH_HOME/keys.zsh"

# read convenient short hands
# also ensures functions do _not_ see the aliases and get messed up logic
source "$ZSH_HOME/aliases.zsh"

# configuring tool hooks in zsh
source "$ZSH_HOME/tools.zsh"

# optionally start up TMUX unless NOTMUX is set
source "$ZSH_HOME/tmux.zsh"
