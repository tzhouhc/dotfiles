#!/usr/bin/env zsh

source $HOME/.zsh/base.zsh

mkdir -p ~/.credentials

openai_clear=$(gum input --prompt="Paste the OpenAI API key here: ")
deepseek_clear=$(gum input --prompt="Paste the DeepSeek API key here: ")

if [[ -n "${openai_clear}" ]]; then
  echo $openai_clear | age -R $HOME/.ssh/id_ed25519.pub -o $HOME/.credentials/openai_key
fi

if [[ -n "${deepseek_clear}" ]]; then
  echo $deepseek_clear | age -R $HOME/.ssh/id_ed25519.pub -o $HOME/.credentials/deepseek_key
fi

