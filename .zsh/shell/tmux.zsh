if [[ "$NOTMUX" == 'true' ]]; then
  return
fi

if [[ -e ~/.notmux ]]; then
  return
fi

if [[ $ZELLIJ != '' ]]; then
  return
fi

if ! [[ -v TMUX ]]; then
  tmux attach -t main &>/dev/null || tmux new -s main
fi
