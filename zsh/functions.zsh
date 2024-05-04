# combination of zoxide and a more liberal cd-experience:
#   - jumps to home if no args given
#   - jumps to the containing dir if given a file
#   - jumps to a dir if it _is_ a dir
#   - jumps to zoxide query if none of the above
function my_cd() {
  if type zoxide >/dev/null 2>&1; then
    cmd=z
  else
    cmd=cd
  fi
  if [ $# -eq 0 ] ; then
    # no arguments
    $cmd
  elif [ -f $1 ] ; then
    # argument is not a directory
    $cmd "$(dirname $1)"
  else
    # argument is a dir or some zoxide moniker
    $cmd "$1"
  fi
}

# start neovim as a server with a fixed socket
#   * create new server if none exist
#   * one server for each tmux window
function supervim() {
  if type nvr >/dev/null 2>&1; then
    # vim internal-terminal mode
    if [[ $NVIM != '' ]]; then
      nvr $@
      return
    fi
    # determine tmux mode
    if [[ $TMUX != '' ]]; then
      window=$(tmux display-message -p '#I')
      expect_name="/tmp/nvimsocket_$window"
    else
      expect_name="/tmp/nvimsocket"
    fi
    if [[ $(vimpane) != '' ]]; then
      NVIM_LISTEN_ADDRESS=$expect_name nvr $@ && gotovim
    else
      # if we are creating a new server, make sure there's no leftover sockets
      # that might lock us out
      rm -f $expect_name
      NVIM_LISTEN_ADDRESS=$expect_name nvim $@
    fi
  else
    nvim $@
  fi
}

# Find the pane containing vim instance in current tmux window
function vimpane() {
  if [[ $TMUX != '' ]]; then
    tmux list-panes -F '#I:#P #{pane_current_command}' | grep nvim | cut -d' ' -f1  | cut -d':' -f2
  fi
}


# if tmux is running, then try to find running vim panel
# will probably fail if no nvim is running
# though this really should only be called from the above supervim cmd
function gotovim() {
  if [[ $TMUX != '' ]]; then
    vim_pane=$(vimpane)
    if [[ $vim_pane != '' ]]; then
      tmux select-pane -t $vim_pane && tmux send-keys Enter
      # the extra step is needed to avoid the hit-enter events due to low
      # cmdheight in nvim.
    else
      echo "Vim is not running in the current window."
      return 1
    fi
  fi
}

# restart current thread
function zsh_reload() {
  exec zsh
}

# record absolute paths of files/folders.
# will not overwrite existing sending targets.
function push() {
  echo $@ | xargs realpath >> ~/.send.temp
}

# show what's in the file pasteboard
function peek() {
  cat ~/.send.temp
}

# emit pushed content to stdout then clear
function pop() {
  cat ~/.send.temp
  rm ~/.send.temp
  touch ~/.send.temp
}

# copy the files over to current directory
function paste_files() {
  cp -r $(pop) ./
}

# same as above, but keeps temp as is
function paste_files_no_flush() {
  cp -r $(peek) ./
}

# move the files over to current directory
function move_files() {
  mv $(pop) ./
}

# display a colored band to test for true color support in the terminal
function check_true_color() {
  awk 'BEGIN{
      s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
      for (colnum = 0; colnum<77; colnum++) {
          r = 255-(colnum*255/76);
          g = (colnum*510/76);
          b = (colnum*255/76);
          if (g>255) g = 510-g;
          printf "\033[48;2;%d;%d;%dm", r,g,b;
          printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
          printf "%s\033[0m", substr(s,colnum+1,1);
      }
      printf "\n";
  }'
}

# some text coloring functions
function red() {
  print -nP "%F{red}$1%f"
}

function green() {
  print -nP "%F{green}$1%f"
}

function blue() {
  print -nP "%F{blue}$1%f"
}

function yellow() {
  print -nP "%F{yellow}$1%f"
}

function magenta() {
  print -nP "%F{magenta}$1%f"
}

function cyan() {
  print -nP "%F{cyan}$1%f"
}

# is the current directory a git repo?
function is_git() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

if [[ $IS_PERSONAL_COMPUTER == 'true' ]]; then
  # open $(cd)
  function o() {
    cwd=$(pwd)
    my_cd $1
    /usr/bin/open .
    cd $cwd
    hide_iterm_window
  }

  # open and then hide iterm window
  function open_and_switch() {
    /usr/bin/open $1
    hide_iterm_window
  }
fi

# mark for general usage -- store a path with a simple alias.
# z is fine but sometimes one needs a bit of a reminder of what things are even
# there to begin with.
function mark() {
  echo "$1\t$PWD" >> ~/.marks
  sort ~/.marks | uniq > ~/.marks.bk
  cp ~/.marks.bk ~/.marks
  rm ~/.marks.bk
}

# See https://github.com/dalance/procs/issues/330
function smart_procs() {
  if [[ $TMUX != '' ]]; then
    procs --theme dark $@
  else
    procs $@
  fi
}

# navi, except result is not run, but instead filled to the command line
function inline_navi() {
  print -z $(env navi --print)
}

# fd except it looks through the entire current repo
function fd_across_repo() {
  # git
  if is_git; then
    pushd "$(git rev-parse --show-toplevel)"
    fd -a $@
    popd
  else
    fd $@
  fi
}
