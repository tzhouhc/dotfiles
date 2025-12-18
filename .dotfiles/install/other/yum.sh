#!/bin/bash
set -e

# only installs basic tools needed for installing homebrew and rust
yum -y groupinstall 'Development Tools'
yum -y install procps-ng curl file git
