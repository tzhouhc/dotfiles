if [[ "$NOTMUX" == 'true' ]]; then
  return
fi

if [[ -e ~/.notmux ]]; then
  return
fi

if [[ $TMUX != '' ]]; then
  return
fi

if [[ $ZELLIJ != '' ]]; then
  # only do it the first time in a zellij tab (?)

  # current issue: every single pane gets a new one
  if [[ $ZELLIJ_TAB == '' ]]; then
    if type petname &>/dev/null; then
      export ZELLIJ_TAB=$(petname)
    else
      export ZELLIJ_TAB=$(shuf -n 1 /usr/share/dict/words)
    fi
  fi
else
  if ! [[ -v ZELLIJ ]]; then
    zellij attach --create main
  fi
fi
