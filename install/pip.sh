#!/bin/bash

if ! type "pip3" > /dev/null; then
  echo "No pip3 found!"
  exit 1
fi

pip3 install ranger-fm flake8 black isort neovim jedi mypy
