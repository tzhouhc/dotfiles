# REFERENCE
# ZSH COLORS: https://user-images.githubusercontent.com/704406/43988708-64c0fa52-9d4c-11e8-8cf9-c4d4b97a5200.png

# system hook functions -- for zshaddhistory
custom_add_history() {
  print -sr -- ${1%%$'\n'}  # standard base implementation
  # now additionally we want to ensure directory-aware history
  echo $PWD#$(echo ${1%%$'\n'} | sed 's/ +$//;s/^ +//') >> $DIR_AWARE_HISTFILE
  cat $DIR_AWARE_HISTFILE | sort -u > $DIR_AWARE_HISTFILE.tmp
  cat $DIR_AWARE_HISTFILE.tmp > $DIR_AWARE_HISTFILE
  rm $DIR_AWARE_HISTFILE.tmp
}
if [[ $DIR_AWARE_HISTFILE != '' ]]; then
  add-zsh-hook zshaddhistory custom_add_history
fi

# custom cd hook -- record folders that we've stepped into
custom_cd() {
    sort -u -m $DIR_HISTFILE <(echo $PWD) >> $DIR_HISTFILE.tmp
    mv $DIR_HISTFILE.tmp $DIR_HISTFILE
}
if [[ $DIR_HISTFILE != '' ]]; then
  add-zsh-hook chpwd custom_cd
fi

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

function wenku() {
  pushd ~/Downloads/Wenku
  wenku8 --no-epub
  popd
}

function supervim() {
  # start neovim as a server with a fixed socket
  #   * create new server if none exist
  #   * one server for each tmux window
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

function vimpane() {
  if [[ $TMUX != '' ]]; then
    tmux list-panes -F '#I:#P #{pane_current_command}' | grep nvim | cut -d' ' -f1  | cut -d':' -f2
  fi
}

function gotovim() {
  # if tmux is running, then try to find running vim panel
  # will probably fail if no nvim is running
  # though this really should only be called from the above supervim cmd
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

function zsh_reload() {
  exec zsh
}

function get_workspace() {
  res=$(short_pwd)
  root=$(echo $res | cut -d$'\n' -f 1)
  printf $root
}

function is_p4() {
  if [[ $(pwd) == /google/src/cloud/tingzhou/* ]]; then
    return 0
  else
    return 1
  fi
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

function pop() {
  cat ~/.send.temp
  rm ~/.send.temp
  touch ~/.send.temp
}

# copy the files over to current directory
function paste_files() {
  cp -r $(pop) ./
}

function paste_files_no_flush() {
  cp -r $(peek) ./
}

function paste_links() {
  ln -s $(pop) ./
}

function paste_links_no_flush() {
  ln -s $(peek) ./
}

# move the files over to current directory
function move_files() {
  mv $(pop) ./
}

function last_exitcode() {
  # shows last command success or failure (and exit code)
  if [[ $? -eq 0 ]]; then
    print -rn -- "%F{cyan} ="
  else
    print -rn -- "%F{red}$? +"
  fi
}

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

# this makes it so fzf won't go searching for files in gitignore paths
if type fd > /dev/null; then
  _fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
  }
  _fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
  }
fi

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

function is_git() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

if [[ $IS_PERSONAL_COMPUTER == 'true' ]]; then
  function o() {
    pushd $(zoxide query $1 | sed -e 's:\~:/Users/tingzhou:' | tr -d '\r') > /dev/null
    /usr/bin/open .
    popd 2>&1 > /dev/null
    hide_iterm_window
  }

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

function inline_navi() {
  print -z $(env navi --print)
}

function fd_across_repo() {
  # git
  if is_git; then
    fd $@ $(git rev-parse --show-toplevel)
  else
    fd $@
  fi
}
