if [ -z "$TMUX" ]; then
  if [[ -e ~/.notmux ]]; then
    # skip tmux
  else
    if [[ "$is_google" == true ]]; then
      # google's tmux variant that allows gnub auth
      tmx2 attach
    else
      tmux attach
    fi
  fi
fi
