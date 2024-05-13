#!/bin/bash
set -e

# only installs basic tools needed for installing homebrew and rust
apt-get update
apt-get install build-essential pkg-config libssl-dev cmake wget
