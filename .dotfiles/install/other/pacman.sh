#!/bin/bash
set -e

# only installs basic tools needed for installing homebrew and rust
pacman -S base-devel procps-ng curl file git
