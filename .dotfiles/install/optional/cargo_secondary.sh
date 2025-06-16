#!/bin/bash
set -e

cargo install --locked --git https://github.com/asciinema/asciinema  # recording
cargo binstall -y bottom # top
cargo binstall -y du-dust  # better disk usage display
cargo binstall -y lolcate-rs  # locate indexer database
cargo binstall -y pipr  # pipeline crafter
cargo binstall -y diskonaut
cargo binstall -y bandwhich
