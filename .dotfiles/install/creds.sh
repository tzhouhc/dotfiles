#!/usr/bin/env zsh

source $HOME/.zsh/base.zsh

mkdir -p ~/.credentials

if ! gh auth status >/dev/null 2>&1; then
  echo "Logging into Github."
  # always use default github.com;
  # always use ssh key for auth;
  # always use web interface, which will fail, then perform the login manually
  # from the host.
  gh auth login -p ssh -h github.com -w
fi

if [[ -f "$HOME/.credentials/openai_key" ]]; then
  if gum confirm "Overwrite existing Openai key?"; then
    openai_clear=$(fetch-secret bece5e4b282e2832880f2a87bf4329f1)
  fi
else
  openai_clear=$(fetch-secret bece5e4b282e2832880f2a87bf4329f1)
fi

if [[ -f "$HOME/.credentials/deepseek_key" ]]; then
  if gum confirm "Overwrite existing Deepseek key?"; then
    deepseek_clear=$(fetch-secret 877f672099afd3e354d63cadea5c14b1)
  fi
else
  deepseek_clear=$(fetch-secret 877f672099afd3e354d63cadea5c14b1)
fi

if [[ -f "$HOME/.credentials/github_key" ]]; then
  if gum confirm "Overwrite existing Github token?"; then
    github_clear=$(fetch-secret 9b9e18cebd82a343bb12d4911bc1653c)
  fi
else
  github_clear=$(fetch-secret 9b9e18cebd82a343bb12d4911bc1653c)
fi

if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
  ssh-keygen
fi

if [[ -n "${openai_clear}" ]]; then
  echo $openai_clear | age -R $HOME/.ssh/id_ed25519.pub \
    -o $HOME/.credentials/openai_key
fi

if [[ -n "${deepseek_clear}" ]]; then
  echo $deepseek_clear | age -R $HOME/.ssh/id_ed25519.pub \
    -o $HOME/.credentials/deepseek_key
fi

if [[ -n "${github_clear}" ]]; then
  echo $github_clear | age -R $HOME/.ssh/id_ed25519.pub -o \
    $HOME/.credentials/github_key
fi
