#!/bin/bash

# Now that PATH is set, check whether the coreutils on top of the list
# is BSD or GNU
if [[ -z $(ls --version 2>/dev/null | grep gnu) ]]; then
  export COREUTILS_VER=BSD
else
  export COREUTILS_VER=GNU
fi
