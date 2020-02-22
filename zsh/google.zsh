# some google stuff
if [[ $IS_GOOGLE == "true" ]]; then
  if [[ -e '/etc/bash_completion.d/g4d' ]]; then
    source /etc/bash_completion.d/g4d
  fi

  # env vars
  export G4MULTIDIFF=1
  export P4DIFF='p4diff'

  # input method for linux
  export GTK_IM_MODULE=ibus
  export XMODIFIERS=@im=ibus
  export QT_IM_MODULE=ibus

  export DIR_HISTFILE="$HOME/.zsh_dir_history"
fi
