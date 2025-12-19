#!/bin/bash
set -e

# nvim handles its own initialization

# navi: setup tldr based cheats
if type navi &>/dev/null; then
  navi repo add denisidoro/navi-tldr-pages
fi
