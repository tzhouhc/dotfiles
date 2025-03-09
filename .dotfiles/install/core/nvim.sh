#!/bin/bash
set -e

PATH=$PATH:$HOME/.cargo/bin

bob install latest
bob use latest
