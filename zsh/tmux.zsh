if [[ "$NOTMUX" == 'true' ]]; then
  return
fi

if [[ -e ~/.notmux ]]; then
  return
fi

tmux attach
