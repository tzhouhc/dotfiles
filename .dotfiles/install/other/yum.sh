#!/bin/bash
set -e

# only installs basic tools needed for installing homebrew and rust
yum groupinstall 'Development Tools'
yum install procps-ng curl file git
