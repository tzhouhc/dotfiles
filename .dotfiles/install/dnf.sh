#!/bin/bash
set -e

# only installs basic tools needed for installing homebrew and rust
dnf install -y procps curl file git pkg-config \
  cmake zsh protobuf-compiler
dnf group install -y development-tools
