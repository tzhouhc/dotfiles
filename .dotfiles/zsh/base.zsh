#!/usr/bin/env zsh
# Base for all zsh invocations, contains all commonly used envs and updated
# PATH to various binaries and functions containing util functions.
#
# Can be sourced as a standalone file for effect. Provides a script with
# basically all the available tools to run just like in the shell.

ZSH_HOME="$HOME/.zsh"
ZSH_ENV_DIR="$ZSH_HOME/env/"

# sets up PATH to get access to installed binaries
source "$ZSH_ENV_DIR/path.zsh"

# source various environment variables
source "$ZSH_ENV_DIR/env.zsh"

# load various utility functions
source "$ZSH_HOME/functions.zsh"
