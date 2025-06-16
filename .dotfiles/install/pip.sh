#!/bin/bash
set -e

cd "$(dirname "$0")"

# neovim compat and nvr for client-server mode
# using --break-system-packages flag; should _not_ be using system pkg manager
# for python packages anyway.
python3 -m pip install -r ./py_requirements.txt --break-system-packages
