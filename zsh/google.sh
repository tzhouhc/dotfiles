# some google stuff
if [ -d '/google' ]; then
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
fi
