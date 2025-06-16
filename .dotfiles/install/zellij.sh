#!/bin/bash
set -e

cd $HOME/.local/bin
wget https://github.com/dj95/zjstatus/releases/latest/download/zjframes.wasm
wget https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm
chmod +x zjframes.wasm
chmod +x zjstatus.wasm
