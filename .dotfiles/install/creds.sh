#!/usr/bin/env zsh

source $HOME/.zsh/base.zsh

mkdir -p ~/.credentials

openai_clear=$(gum input --prompt="Paste the OpenAI API key here: ")
deepseek_clear=$(gum input --prompt="Paste the DeepSeek API key here: ")
github_clear=$(gum input --prompt="Paste the Github token here: ")

if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
  ssh-keygen
fi

if [[ -n "${openai_clear}" ]]; then
  echo $openai_clear | age -R $HOME/.ssh/id_ed25519.pub -o $HOME/.credentials/openai_key
fi

if [[ -n "${deepseek_clear}" ]]; then
  echo $deepseek_clear | age -R $HOME/.ssh/id_ed25519.pub -o $HOME/.credentials/deepseek_key
fi

if [[ -n "${github_clear}" ]]; then
  echo $github_clear | age -R $HOME/.ssh/id_ed25519.pub -o $HOME/.credentials/github_key
fi
