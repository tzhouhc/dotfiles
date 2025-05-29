#!/usr/bin/env zsh

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

cd "$(dirname "$0")"

print_status() {
  local name=$1
  local length=$2
  local exit_status=$3

  if [[ $exit_status -eq 0 ]]; then
    printf "${YELLOW}%-${length}s${NC} -> ${GREEN}✓${NC}\n" ${name}
  else
    printf "${YELLOW}%-${length}s${NC} -> ${RED}𐄂${NC}\n" ${name}
  fi
}

# -------------

main_bins=(tmux zellij git wget brew fzf fd lazygit gum tldr mods bat atuin eza choose delta just navi rg yazi zoxide nvim git-auto)

echo "Running crucial binary presence check:"

for bin in $main_bins
do
  type ${bin} &>/dev/null
  print_status ${bin} 10 $?
done

# -------------

if [[ -z "$(rg --version | grep "PCRE" | grep "is available")" ]]; then
  printf "Ripgrep ${RED} doesn't have PCRE2 support${NC}."
else
  printf "Ripgrep ${GREEN} has PCRE2 support${NC}."
fi

# -------------

echo "Running commonly used ENV var check:"

env_vars=(XDG_CONFIG_HOME OPENAI_API_KEY OPENROUTER_API_KEY EDITOR GIT_EDITOR)
for env_var in $env_vars
do
  [[ -n ${${env_var}} ]]
  print_status ${env_var} 20 $?
done

# -------------

echo "Verifying neovim version:"

if [[ $(nvim -v) =~ "NVIM v0.1" ]]; then  # v0.10+
  printf "nvim version ${GREEN}up-to-date${NC}.\n"
else
  printf "nvim version ${RED}too old${NC}.\n"
fi

# -------------

echo "Rerunning deployment script:"

pushd ..
./deploy.sh
popd
