#!/usr/bin/env zsh

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

main_bins=(tmux git wget brew stow ag fzf fd lazygit gum tldr mods bat atuin eza choose delta just navi rg yazi zoxide nvim)

echo "Running crucial binary presence check:"

for bin in $main_bins
do
  if type ${bin} &>/dev/null; then
    printf "%-10s -> ${GREEN}✓${NC}\n" ${bin}
  else
    printf "%-10s -> ${RED}𐄂${NC}\n" ${bin}
  fi
done
