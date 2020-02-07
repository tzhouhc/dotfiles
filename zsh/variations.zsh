#!/bin/bash

# Now that PATH is set, check whether the coreutils on top of the list
# is BSD or GNU
if [[ -z $(ls --version 2>/dev/null | grep gnu) ]]; then
  export COREUTILS_VER=BSD
else
  export COREUTILS_VER=GNU
fi

# run if 'ggrep' exists on path
if type ggrep >/dev/null 2>&1; then
  alias grep=$(which ggrep)
fi
