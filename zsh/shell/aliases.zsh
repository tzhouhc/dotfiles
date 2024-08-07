alias vim=supervim
alias vi=nvim  # in case multiple open vim windows are needed
alias g=git
alias v=supervim
alias fbv="v -u $VIM_HOME/fallback.lua"
alias clear="clear -x"  # keep scrollback

# go to level above cwd
alias '..'='cd ..'
alias '...'='cd ../..'
alias '....'='cd ../../..'
alias '.....'='cd ../../../..'
# return to previous wd
alias -- -="cd -"
alias d="dirs -v"
alias 0="cd +0"
alias 1="cd +1"
alias 2="cd +2"
alias 3="cd +3"
alias 4="cd +4"

alias notes="v $HOME/.notes"

# kek
alias :w="echo 'you are not in vim'"
alias :q="echo 'you are not in vim'"
alias :wq="echo 'you are not in vim'"

alias sed='sed -E'

alias vimdiff='nvim -d'

# typo
alias claer=clear
alias cl=clear

# use custom variant that also hides the terminal after opening
if uname -a | grep -i darwin > /dev/null; then
  alias open=open_and_switch
fi

# Aliasing some shiny new tools over classic ones
# note: mainly the interactive ones -- the other ones might be used as part of
# some tool chain
if type zoxide >/dev/null 2>&1; then
  alias cd=my_cd
fi

if type delta >/dev/null 2>&1; then
  alias diff=delta
fi


if type bat >/dev/null 2>&1; then
  alias less=bat
fi

if type eza >/dev/null 2>&1; then
  alias ls='eza --icons=always --no-quotes --group-directories-first --ignore-glob=".DS_Store|Icon?"'
else
  if [[ -z $(ls --version 2>/dev/null | grep gnu) ]]; then
    # GNU
    alias ls='ls -G'
    # BSD
  else
    alias ls='ls -N --color -h --sort=extension --group-directories-first -v'
  fi
fi
alias l=ls

if type procs >/dev/null 2>&1; then
  alias ps=smart_procs
  alias procs=smart_procs
fi

if type dust >/dev/null 2>&1; then
  alias du='dust -d1 -r -B -z=1MB -w=80'
fi

if type navi >/dev/null 2>&1; then
  alias navi=inline_navi
fi

if type btm >/dev/null 2>&1; then
  alias top=btm
fi

if type btop >/dev/null 2>&1; then
  alias top=btop
fi

if type just >/dev/null 2>&1; then
  alias j=just
fi

# run if 'ggrep' exists on path
if type ggrep >/dev/null 2>&1; then
  alias grep=ggrep
fi

if type rip >/dev/null 2>&1; then
  alias rm=rip
fi

if type lazygit >/dev/null 2>&1; then
  if [[ $NERDFONT == '2' ]]; then
    alias lg='lazygit -ucf=$XDG_CONFIG_HOME/lazygit/config_backup.yml'
  else
    alias lg=lazygit
  fi
fi

if type tmux_notify &>/dev/null; then
  alias tin=tmux_notify
fi

if type oh-my-posh &>/dev/null; then
  alias omp=oh-my-posh
fi

if type evcxr &>/dev/null; then
  alias rust=evcxr
fi

if type lolcate &>/dev/null; then
  alias locate=lolcate
fi
