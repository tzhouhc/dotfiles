if [[ "$NOTMUX" == 'true' ]]; then
  return
fi

if [[ -e ~/.notmux ]]; then
  return
fi

if ! [[ -v TMUX ]]; then
  tmux attach -t main || tmux new -s main
fi
