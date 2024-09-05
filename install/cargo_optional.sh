#!/bin/bash
set -e

cargo install --locked --git https://github.com/asciinema/asciinema  # recording
cargo install --locked bacon  # rust compiling and testing
cargo install --locked typst-cli  # latex replacement

cargo install aichat  # chatgpt, gemini, etc
cargo install atac  # requests
cargo install bottom --locked  # top
cargo install du-dust  # better disk usage display
cargo install evcxr_repl  # repl for rust
cargo install lolcate-rs  # locate indexer database
cargo install nu  # shell for data
cargo install pipr  # pipeline crafter
cargo install procs  # ps
cargo install tv  # csv viewer
cargo install zellij  # tmux
cargo install cargo-cache  # clear cargo cache
