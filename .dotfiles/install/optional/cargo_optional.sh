#!/bin/bash
set -e

cargo install --locked bacon  # rust compiling and testing
cargo install --locked typst-cli  # latex replacement

cargo install atac  # requests
cargo install nu  # shell for data
cargo install procs  # ps
cargo install tv  # csv viewer
cargo install cargo-cache  # clear cargo cache
cargo install --git https://github.com/lotabout/rargs.git  # xargs
