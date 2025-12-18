#!/bin/bash
set -e

# only installs basic tools needed for installing homebrew and rust
apk update
apk add --no-cache build-base procps curl file pkgconfig libssl-dev \
  cmake zsh

