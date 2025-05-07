#!/bin/bash
set -e

cd "$(dirname "$0")"

if ! type "pip3" > /dev/null; then
  echo "pip3 not found!"
  exit 1
fi

# neovim compat and nvr for client-server mode
# using --break-system-packages flag; should _not_ be using system pkg manager
# for python packages anyway.
python3 -m pip install -r ./py_requirements.txt --break-system-packages
