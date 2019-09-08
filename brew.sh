#!/bin/bash

if ! type "brew" > /dev/null; then
  echo "No brew found! Installing."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
