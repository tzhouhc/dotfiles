# Shell functions that serve a simple goal by themselves, but can also be
# invoked from more sophisticated functions.

# combination of zoxide and a more liberal cd-experience:
#   - jumps to home if no args given
#   - jumps to the containing dir if given a file
#   - jumps to a dir if it _is_ a dir
#   - jumps to zoxide query if none of the above
#   - checks lolcate for unknown target to zoxide
function smart_cd() {
  if [ $# -eq 0 ] || [ -z "$1" ] ; then
    # no arguments, go home by default
    cd
  elif [ -d "$1" ]; then
    # argument is a current dir; go into it
    cd "$1"
  elif [ -f $1 ] ; then
    # argument is a file; go to containing dir
    cd "$(dirname $1)"
  else
    # argument is some zoxide moniker or something unknown
    # first try to invoke zoxide;
    # if zoxide fails, then ask lolcate to try and find the dir.
    # then use fzf to choose from possible results.
    if ! z "$1" &>/dev/null ; then
      if type lolcate &>/dev/null; then
        # argument is not known to zoxide
        target=$(lolcate --db dirs "$1" | fzf --preview="smart_preview {}")
        if [ -z "$target" ] ; then
          # fzf cancel
          return
        fi
        smart_cd "$target"
      fi
    fi
  fi
}

# like smart_cd, but does not use zoxide.
function smart_cd_no_z() {
  if [ $# -eq 0 ] || [ -z "$1" ] ; then
    # no arguments, go home by default
    cd
  elif [ -d "$1" ]; then
    # argument is a current dir; go into it
    cd "$1"
  elif [ -f $1 ] ; then
    # argument is a file; go to containing dir
    cd "$(dirname $1)"
  else
    locs=$(lolcate --db dirs "$1")
    count=$(echo $locs | wc -l)
    if [ $count -eq 0 ] ; then
      return
    elif [ $count -eq 1 ] ; then
      cd $locs
    else
      target=$(echo $locs | fzf --preview="smart_preview {}")
      cd "$target"
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

# Copy file from some specified location to cwd
function copy() {
  if [[ -z "$@" ]]; then
    return
  fi
  cp $@ ./
}

# Move file from some specified location to cwd
function grab() {
  if [[ -z "$@" ]]; then
    return
  fi
  mv $@ ./
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

# Function to match the current working directory against common system
# paths and return a Nerd Font icon
function get_nerd_font_icon() {
    local current_dir=$(pwd)
    local icon=""

    case $current_dir in
        */vim*) icon="";;
        */.dotfiles*) icon="";;
        */.git*) icon="󰊢";;
        */Columbia*) icon="󰑴";;
        */Documents*) icon="";;
        */Downloads*) icon="";;
        */Library*) icon="";;
        */Pictures*) icon="";;
        */Music*) icon="";;
        */Videos*) icon="";;
        */Desktop*) icon="";;
        */tingzhou*) icon="";;
        /*) icon="";;
        *) icon="";;
    esac

    echo $icon
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
function pipe_to_less() {
    $SHELL -i -c "$(fc -ln -1) | bat"
}

function file_full_path() {
  print $(readlink -f "$1")
}

function cse() {
  if [[ -z $@ ]]; then
    echo "csearch needs input."
    return 0;
  fi
  result=$(csearch -n $@ | fzf --height 40% --reverse -d':' --preview="fzf-bat-preview {1} {2}")
  file=$(echo $result | cut -d':' -f1)
  line=$(echo $result | cut -d':' -f2)
  if [[ -n $file ]]; then
    supervim "${file}" +$line
  fi
}

function csv() {
  if [[ -z $@ ]]; then
    echo "csearch needs input."
    return 0;
  fi
  result=$(csearch -n $@ | fzf --height 40% --reverse -d':' --preview="fzf-bat-preview {1} {2}")
  file=$(echo $result | cut -d':' -f1)
  line=$(echo $result | cut -d':' -f2)
  if [[ -n $file ]]; then
    bat "${file}" -H $line --pager="less +${line}G"
  fi
}

# Execute the command and capture its output
function to_next() {
  local command_output
  command_output=$("$@" 2>/dev/null)
  # Store the output in the shell's readline buffer
  print -z "$(echo -n "$command_output" | tr -d '\n')"
}

# take a link and replace it with where the link is pointing to.
function unsymlink() {
    link="$1"

    if [ -L "$link" ]; then
        target=$(readlink -f "$link")

        if [ -d "$target" ]; then
            rm "$link"
            cp -r "$target" "$link"
            echo "Replaced directory symlink $link with copy of $target"
            echo "$target -> $link" >> "$HOME/links.txt"
            echo "$link" >> "$HOME/links_result.txt"
        else
            rm "$link"
            cp "$target" "$link"
            echo "Replaced file symlink $link with copy of $target"
            echo "$target -> $link" >> "$HOME/links.txt"
            echo "$link" >> "$HOME/links_result.txt"
        fi
    else
        echo "$link is not a symlink, skipping"
    fi
}

function history_replay() {
  print -z $(atuin history list | tail -n 50 | head -n 49 | \
    fzf -m --bind 'result:pos(-4)' | cut -f 2 | \
    awk '{printf("%s%s", sep, $0); sep=" ; "} END {print ""}')
}
alias replay=history_replay

function shell_open() {
  if [[ -d $1 ]]; then
    cd $1
  elif [[ -f $1 ]]; then
    if file "$1" --mime-type | grep -Eq 'text'; then
      nvim "$1"
    fi
  fi
}
