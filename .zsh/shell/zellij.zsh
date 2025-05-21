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
  zellij_tab_name_update() {
    local current_dir=$PWD
    if [[ $current_dir == $HOME ]]; then
        current_dir="~"
    else
        current_dir=${current_dir##*/}
    fi
    command nohup zellij action rename-tab $current_dir >/dev/null 2>&1
  }

  zellij_tab_name_update
  chpwd_functions+=(zellij_tab_name_update)
else
  if [[ "$NOTMUX" == 'true' ]]; then
    return
  fi

  if [[ -e ~/.notmux ]]; then
    return
  fi

  if [[ $TMUX != '' ]]; then
    return
  fi

  if ! [[ -v ZELLIJ ]]; then
    zellij attach --create main
  fi
fi
