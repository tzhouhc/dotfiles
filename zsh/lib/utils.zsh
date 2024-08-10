# Shell functions that serve a simple goal by themselves, but can also be
# invoked from more sophisticated functions.

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
    # if failed to zoxide then try to just cd to the containing dir
    if ! $cmd "$1" ; then
      cd $(dirname "$1")
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

# is the current directory a git repo?
function is_git() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

# root dir of current git repo
function git_repo_root() {
  git rev-parse --show-toplevel
}

# cd to git repo root
function gcd() {
  cd $(git_repo_root)
}

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

# open and then hide iterm window
# used as an alias for open
function open_and_switch() {
  /usr/bin/open $@
  hide_iterm_window
}

# check if file or directory is in an obsidian vault
function is_ob_vault() {
  dir=$1
  if [[ "$dir" == '' ]]; then
    dir=$(pwd)
  fi
  while [[ $dir != '/' ]]; do
    if ls -a "$dir" | grep -Eq '.obsidian'; then
      return 0
    fi
    dir=$(dirname "$dir")
  done
  return 1
}

# open a file in obsidian (assuming it is in a vault)
function open_in_ob() {
  file_path=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$1'''))")
  open "obsidian://open?path=$file_path"
}

# if current dir contains a python venv, invoke it
function venv() {
  if [[ -d '.venv' ]]; then
    source ./.venv/bin/activate
  fi
}

# for checking terminal key codes
function what_am_i_typing() {
  STTY='raw -echo min 0 time 40' cat -vte
}

# take previous cmd output and pipe to bat
pipe_to_less() {
    $SHELL -i -c "$(fc -ln -1) | bat"
}
