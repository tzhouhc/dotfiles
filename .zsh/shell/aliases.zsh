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

alias remake='make clean && make'

# vmware
alias vmrun="/Applications/VMware\ Fusion.app/Contents/Library/vmrun"

# for school specifically
alias start_virt="vmrun -T fusion start ~/Virtual\ Machines.localized/OS_Ubuntu.vmwarevm/OS_Ubuntu.vmx nogui"
alias stop_virt="vmrun -T fusion suspend ~/Virtual\ Machines.localized/OS_Ubuntu.vmwarevm/OS_Ubuntu.vmx"
alias pause_virt="stop_virt"

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
if type zoxide &>/dev/null; then
  alias cd=smart_cd
  if type lolcate &>/dev/null; then
    alias cdd=smart_cd_no_z
    alias zz=smart_cd_no_z
  fi
fi

if type delta >/dev/null 2>&1; then
  alias diff=delta
fi

if type bat >/dev/null 2>&1; then
  alias less=bat
fi

if type eza >/dev/null 2>&1; then
  alias ls='eza --icons=auto --no-quotes --group-directories-first --ignore-glob=".DS_Store|Icon?"'
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

alias dfg='git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME'
alias dflg='lazygit --git-dir=$HOME/.dotfiles.git --work-tree=$HOME'
alias dfe='$EDITOR $(dfg ls-files . | fzf)'

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

if type cmus &>/dev/null; then
  actual=$(which cmus)
  # alias cmus="tmux new-session -s cmus -d "$actual" 2> /dev/null; tmux switch-client -t cmus"
  alias cmus='screen -q -r -D cmus || screen -S cmus "$actual"'
fi

if type glow &>/dev/null; then
  alias glow="glow -p"
fi

if type wezvim &>/dev/null; then
  alias wv=wezvim
fi

if type mods &>/dev/null; then
  function modsh() {
    to_next mods -q --role shell_stdout $@ 2>/dev/null
  }
  function task_ai() {
    to_next mods -q --role task_warrior $@ 2>/dev/null
  }
  chat() {
    # pick a model alias from your config
    model=$(echo "4o\n4o-mini\nds-chat\nds-r1" \
      | gum choose --height 8 --header "Pick model to chat with:" --no-show-help)
    if [[ -z $model ]]; then
      gum format "  :pensive:  cancelled, no model picked." -t emoji
      return 1
    fi
    # first invocation starts a new conversation
    mods --model "$model" --prompt-args $@ || return $?
    # after that enter a loop until user quits
    while mods --model "$model" --prompt-args $@ --continue-last; do :; done
    return $?;
  }
  alias howto=modsh
  alias todo=task_ai
  alias catsh='mods --api deepseek --model deepseek-chat --role cat'
fi

if ! type open &>/dev/null; then
  if type xdg-open &>/dev/null; then
    alias open=xdg-open
  fi
fi

if type bazel &>/dev/null; then
  alias bb="bazel build"
  alias br="bazel run"
  alias bt="bazel test"
fi

if type task &>/dev/null; then
  alias t="task"
fi

