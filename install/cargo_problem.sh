#!/bin/bash
set -e

export PATH=$HOME/.cargo/bin:$PATH

cargo install kalker   # calculator
# This guy tends to have some issue with m4. Plus it's not really used.
