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

# Aliasing some shiny new tools over classic ones
# note: mainly the interactive ones -- the other ones might be used as part of
# some tool chain
if type zoxide &>/dev/null; then
  alias cd=smart_cd
fi

alias diff=delta
alias less=bat

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

alias du='dust -d1 -r -B -z=1MB -w=80'

alias top=btop
alias j=just

# run if 'ggrep' exists on path
alias grep=ggrep
alias fd="fd --hidden --exclude '.git'"
alias rm=rip
alias tree=erd

if [[ $NERDFONT == '2' ]]; then
  alias lg='lazygit -ucf=$XDG_CONFIG_HOME/lazygit/config_backup.yml'
else
  alias lg=lazygit
fi

alias dfg='git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME'
alias dflg='lazygit --git-dir=$HOME/.dotfiles.git --work-tree=$HOME'
alias pfg='git --git-dir=$HOME/.private.git --work-tree=$HOME'
alias pflg='lazygit --git-dir=$HOME/.private.git --work-tree=$HOME'
alias dfe='$EDITOR $(dfg ls-files . | fzf)'

alias omp=oh-my-posh

if type evcxr &>/dev/null; then
  alias rust=evcxr
fi

if type cmus &>/dev/null; then
  actual=$(which cmus)
  # alias cmus="tmux new-session -s cmus -d "$actual" 2> /dev/null; tmux switch-client -t cmus"
  alias cmus="screen -q -r -D cmus || screen -S cmus $actual"
fi

alias glow="glow -p"
alias wv=wezvim

if type mods &>/dev/null; then
  function modsh() {
    to_next mods -q --role shell_stdout $@ 2>/dev/null
  }
  function task_ai() {
    to_next mods -q --role task_warrior $@ 2>/dev/null
  }
  function chat() {
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
  function explain() {
    mods --role shell_expln $@
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

alias bb="bazel build"
alias br="bazel run"
alias bt="bazel test"
alias bc="bazel clean"
alias blaze="bazel"

alias t="task"
alias hex="hexyl"
alias zel="zellij attach --create main"
alias rsyncs="rsync -avh --progress --delete --stats"
alias whatis="magika"
