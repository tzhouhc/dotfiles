#!/bin/bash
set -e

cwd="$(dirname "$0")"
cwd="$(cd $cwd; pwd)"

if uname -a | grep -i darwin > /dev/null; then
  $cwd/install/brew.sh
else
  sudo $cwd/install/apt.sh
fi

source $cwd/install/pip.sh
