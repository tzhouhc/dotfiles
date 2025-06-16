#!/bin/bash
set -e

cargo binstall -y bacon  # rust compiling and testing
cargo binstall -y typst-cli  # latex replacement

cargo binstall -y atac  # requests
cargo binstall -y nu  # shell for data
cargo binstall -y procs  # ps
cargo binstall -y cargo-cache  # clear cargo cache
cargo install --git https://github.com/lotabout/rargs.git  # xargs
