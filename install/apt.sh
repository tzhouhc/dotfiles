#!/bin/bash
set -e

# only installs basic tools needed for installing homebrew and rust
apt-get update
apt-get install build-essential procps curl file git pkg-config libssl-dev \
  cmake 
