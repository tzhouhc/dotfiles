#!/usr/bin/env zsh
# Base for all zsh invocations, contains all commonly used envs and updated
# PATH to various binaries and functions containing util functions.

ZSH_HOME="$HOME/.zsh"

# sets up PATH to get access to installed binaries
source "$ZSH_HOME/path.zsh"

# source various environment variables
source "$ZSH_HOME/env.zsh"

# load various utility functions
source "$ZSH_HOME/functions.zsh"
