if [[ "$NOTMUX" == 'true' ]]; then
else
  if [ -z "$TMUX" ]; then
    if [[ -e ~/.notmux ]]; then
      # skip tmux
    else
      if [[ "$IS_GOOGLE" == true ]]; then
        # google's tmux variant that allows gnub auth
        tmx2 attach
      else
        tmux attach
      fi
    fi
  fi
fi
