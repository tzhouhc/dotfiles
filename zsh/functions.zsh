# REFERENCE
# ZSH COLORS: https://user-images.githubusercontent.com/704406/43988708-64c0fa52-9d4c-11e8-8cf9-c4d4b97a5200.png

typeset -gA branch_icon_map
branch_icon_map[Documents]="󰈙 "
branch_icon_map[Downloads]=" "
branch_icon_map[Desktop]=" "
branch_icon_map[Movies]="󰎁"
branch_icon_map[Pictures]=" "
branch_icon_map[Library]=" "
branch_icon_map[Music]=" "
branch_icon_map[search]=" "
branch_icon_map[evaluation]="󰍉 "
branch_icon_map[logs]=" "
branch_icon_map[blaze-out]=" "
branch_icon_map[blaze-bin]=" "
branch_icon_map[production]=" "
branch_icon_map[configs]=" "

source ~/.zsh/lib/gitstatus/gitstatus.plugin.zsh
gitstatus_stop 'MY' && gitstatus_start -s -1 -u -1 -c -1 -d -1 'MY'

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

cd() {
  if [ $# -eq 0 ] ; then
    # no arguments
    builtin cd
  elif [ -d $1 ] ; then
    # argument is a directory
    builtin cd "$1"
  else
    # argument is not a directory
    builtin cd "$(dirname $1)"
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

function run() {
  /usr/bin/open $1
}

function unicode() {
  echo -e "\u$1"
}

function get_workspace() {
  res=$(short_pwd)
  root=$(echo $res | cut -d$'\n' -f 1)
  printf $root
}

# THIS IS THE ACTUAL SHELL PROMPT
function prompt_short_pwd() {
  res=$(short_pwd)
  root=$(echo $res | cut -d$'\n' -f 1)
  branch=$(echo $res | cut -d$'\n' -f 2)
  depth=$(echo $res | cut -d$'\n' -f 3)
  base=$(echo $res | cut -d$'\n' -f 4)

  if [[ $root == "/" ]]; then
    p10k segment -b red -f black -t 
  elif [[ $root == "~" ]]; then
    p10k segment -b springgreen4 -f black -t 
  else
    p10k segment -b grey23 -f orangered1 -t $root
  fi

  # this is to provide a little reminder of the overall
  # branch that we are currently in
  if [[ $branch != "" ]] && [[ $depth -ge 1 ]]; then
    branch_icon=${branch_icon_map[$branch]}
  fi

  if [[ $depth -ge 1 ]]; then
    if [[ $branch_icon != "" ]]; then
      p10k segment -b khaki1 -f black -t "$branch_icon$depth"
    else
      p10k segment -b khaki1 -f black -t $depth
    fi
  fi

  if [[ $depth -ge 0 ]]; then
    p10k segment -b skyblue1 -f black -t $base
  fi
}

function git_dirty() {
  if git diff --quiet; then
    return 1
  else
    return 0
  fi
}

function is_git() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

function is_p4() {
  if [[ $(pwd) == /google/src/cloud/tingzhou/* ]]; then
    return 0
  else
    return 1
  fi
}

function prompt_gitstatus() {
  if gitstatus_query MY && [[ $VCS_STATUS_RESULT == ok-sync ]]; then
    message=${${VCS_STATUS_LOCAL_BRANCH:-@${VCS_STATUS_COMMIT}}//\%/%%}  # escape %
    message+=' '
    color=green
    (( $VCS_STATUS_COMMITS_AHEAD )) && message+="$VCS_STATUS_COMMITS_AHEAD "
    (( $VCS_STATUS_COMMITS_BEHIND )) && message+="$VCS_STATUS_COMMITS_BEHIND "
    (( $VCS_STATUS_NUM_STAGED    )) && message+=' ' && color=yellow
    (( $VCS_STATUS_NUM_UNSTAGED  )) && message+=' ' && color=yellow
    (( $VCS_STATUS_NUM_UNTRACKED )) && message+=' '
    [[ $color == green ]] && message+=''
    message=$(echo $message | sed 's/ +/ /g' | sed 's/ $//')
    p10k segment -b $color -f black -t $message
  fi
}

function prompt_small_status() {
  # shows last command success or failure (and exit code)
  if [[ $_p9k_status -eq 0 ]]; then
    p10k segment -b grey23 -f green -t ""
  else
    p10k segment -b grey23 -f red -t "$_p9k_status "
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

# customized prompt
# LEGACY -- use in case of no powerline support
function google3_prompt_info() {
  # shows current dir name;
  # if in citc, shows citc client name plus current folder depth
  if [[ $PWD =~ '/google/src/cloud/[^/]+/([^/]+)/?(.*)' ]]; then
    # Use CitC client names as window titles in screen/tmux
    # print -n "\ek${match[1]}\e\\"  # not sure what this is for anymore
    if [[ -z ${match[2]} ]]; then
      print -r -- "%F{blue}($match[1])%F{yellow}/"
    else
      depth=$(echo ${match[2]} | awk -F"/" '{print NF-1}')
      if [[ $depth == 0 ]]; then
        print -r -- "%F{blue}($match[1])%F{yellow}/%F{green}%B$(basename ${match[2]#/})%b"
      else
        print -r -- "%F{blue}($match[1])%F{yellow}/+$depth/%F{green}%B$(basename ${match[2]#/})%b"
      fi
    fi
  elif [[ $PWD =~ "$HOME(.*)" ]]; then
    depth=$(echo ${match[1]} | awk -F"/" '{print NF-1}')
    if [[ $depth == -1 ]]; then
      print -r -- "%F{cyan}%B~%b"
    elif [[ $depth == 1 ]]; then
      print -r -- "%F{cyan}~/%F{green}%B$(basename ${match[1]})%b"
    else
      depth=$((depth - 1))
      print -r -- "%F{cyan}~%F{yellow}/+$depth/%F{green}%B$(basename ${match[1]})%b"
    fi
  else
    depth=$(echo $PWD | awk -F"/" '{print NF-1}')
    if [[ $depth == 1 ]]; then
      print -r -- "%F{red}%B$PWD%b"
    else
      depth=$((depth - 1))
      print -r -- "%F{red}/%F{yellow}+$depth/%F{green}%B$(basename $PWD)%b"
    fi
  fi
}

function last_exitcode() {
  # shows last command success or failure (and exit code)
  if [[ $? -eq 0 ]]; then
    print -rn -- "%F{cyan} ="
  else
    print -rn -- "%F{red}$? +"
  fi
}

function hg_branch() {
  branch=$(hg branch 2>&1)
  if [[ $? -eq 0 ]]; then
    print -rn -- "[%F{magenta}$(hg prompt '{branch}{status}')%f] "
  else
    print -rn -- " "
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

if [[ $IS_PERSONAL_COMPUTER == 'true' ]]; then
  function mount_music() {
    sshfs nookie:/media/synia/music $HOME/Music/Synia
  }

  function cmus() {
    if ls $HOME/Music/Synia | grep albums >/dev/null; then
      /usr/local/bin/cmus
    else
      mount_music
      /usr/local/bin/cmus
    fi
  }

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

  function critical_role_by_script() {
    pushd $CRITICAL_ROLE_PATH > /dev/null 2>&1
    cat ./* | fzf -m -d"\t" --exact --with-nth 2 --preview='ln={5}; sed -n $ln,$[$ln + 50]p {4} | cut -f1,2' | cut -d$'\t' -f3
    popd > /dev/null 2>&1
  }
fi

function batrange() {
  print $[$[$1 - 3] < 0 ? 0 : $[$1 - 3]]:$[$ln + 20]
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

# --------
# Google stuff
# --------

# jump to java test folder of the same package
function jt() {
  if [[ $PWD =~ '(.*)/javatests(.*)' ]]; then
      cd "${match[1]}/java${match[2]}"
  else
      cd "${PWD/\/google3\/java//google3/javatests}"
  fi
}

function csfind() {
  # empty query to csfind gets data from the last query
  # so that one query can be reused multiple times
  if [[ $@ != '' ]]; then
    echo "Querying CS..."
    cs --nostats --local -n $@ 2>/dev/null | cut -d':' -f1-2 | cut -d'/' -f7- | sed 's/\:/ /' > ~/.last_cs
  else
    touch ~/.last_cs
  fi
  cat ~/.last_cs | fzf --preview "ln={2}; bat -H \$ln -r \$[\$[\$ln - 3] < 0 ? 0 : \$[\$ln - 3]]:\$[\$ln + 40] --theme zenburn /google/src/files/head/depot/{1}"
}

function csedit() {
  output=$(csfind $@)
  # allow ^c early escape
  if [[ $? == 0 ]]; then
    read -r file num <<< $(echo $output)
    if [[ $(g4pwd) != '' ]]; then
      # open local citc version so that we can start editing
      vim $(g4pwd)/$file +$num
    else
      # Read-only view into latest source
      vim /google/src/files/head/depot/$file +$num
    fi
  else
    exit $?
  fi
}

function cshere() {
  cs "file://depot/google3/$(pwd | cut -d'/' -f8-) $@"
}

# show current citc client full path
function g4pwd() {
  if [[ $PWD =~ '(/google/src/cloud/[^/]+/[^/]+)' ]]; then
    echo $match[1]
  fi
}

function g4name() {
  echo "$(g4pwd | rev | cut -d'/' -f1 | rev)"
}

# show current rel path under google3
function g4pwd2() {
  if [[ $PWD =~ '/google/src/cloud/[^/]+/[^/]+/google3/(.+)' ]]; then
    echo $match[1]
  fi
}

# build, then go to the blaze-out directory
function bbs() {
  [[ $PWD =~ '(/google/src/cloud/[^/]+/[^/]+)/(.*)' ]]
  citc_path=$match[1]
  blaze_path="$(blaze build $@ 2>&1 | grep blaze-out)"
  blaze_path=${blaze_path// /}
  if [[ ! -z $blaze_path ]]; then
    print -P "%F{green}Target built; cd-ing now"
    cd "$citc_path/google3/$(dirname $blaze_path)"
  else
    print -P "%F{red}Target not found; fix something maybe?"
    exit 1
  fi
}

# open test log in $EDITOR if test result is no good
# TODO: investigate why $() removes color from stderr
function btlog() {
  output=$(bt $@)
  if [[ $? != 0 ]]; then
    $EDITOR $(echo $output | grep "test.log")
  fi
}

# mark for google3 -- disregard the workspace and go to short-path
# this is needed over normal z since z no longer works if we change client
function g3mark() {
  if [[ $PWD =~ '(/google/src/cloud/[^/]+)/([^/]+)/google3/(.*)' ]]; then
    remainder=$match[3]
    echo "$1\t$remainder" >> ~/.g3marks
    sort ~/.g3marks | uniq > ~/.g3marks.bk
    cp ~/.g3marks.bk ~/.g3marks
    rm ~/.g3marks.bk
  else
    echo "Not in a google3 folder, simply use 'bookmark' instead."
  fi
}

function editmarks() {
  $EDITOR ~/.g3marks
}

# generate a link to CS for current directory
function cslink() {
  if [[ $PWD =~ '(/google/src/cloud/[^/]+)/([^/]+)/google3/(.*)' ]]; then
    remainder=$match[3]
    echo "https://source.corp.google.com/piper///depot/google3/$remainder/$1"
  fi
}

# generate a link to cider for current directory
function ciderlink() {
  if [[ $PWD =~ '(/google/src/cloud/[^/]+)/([^/]+)/google3/(.*)' ]]; then
    remainder=$match[3]
    file=$(local_file_list | sed s/\"//g)
    echo "http://cider-v/?ws=$(g4name)&files=//depot/google3/$(g4pwd2)/$file"
  fi
}

# cd to specified short-path under the piper client
function g4cd() {
  if [[ $1 == google3/* ]]; then
    cd "$(g4pwd)/$1"
  else
    cd "$(g4pwd)/google3/$1"
  fi
}

function g4do() {
  pushd "$(g4pwd)/google3" >/dev/null
  "$@"
  popd >/dev/null
}

# cd to current path but under blaze-bin instead
function g4bin() {
  if g4pwd2 | grep blaze-bin > /dev/null; then
  else
    cd "$(g4pwd)/google3/blaze-bin/$(g4pwd2)"
  fi
}

function p4cd() {
  set -o pipefail
  target=$(p4_change_list)
  if [[ $target != "" ]]; then
    cd $(echo $target | sed 's/[^\/]*$//')
  fi
}
# edit files that are open in the client
function p4d() {
  set -o pipefail
  target=$(p4_change_list)
  if [ $? -eq 0 ]; then
    p4 diff $target
  fi
}
# edit files that are open in the client
function p4e() {
  set -o pipefail
  if [[ $@ == '' ]]; then
    target=$(p4_change_list)
  else
    target="$(g4pwd)/$@"
  fi
  if [[ $target != "" ]]; then
    # extra echo to prevent editor from consuming all as a single line
    supervim $(echo $target)
  fi
  set +o pipefail
}

# select files to revert in the client
function p4_choose_revert() {
  p4 revert $(p4_full_change_list)
}

function fileutile() {
  tmpname=$(mktemp)
  if fileutil test -f $1; then
    fileutil cat $1 > $tmpname
    $EDITOR $tmpname
    fileutil cp -f $tmpname $1
    rm $tmpname
  else
    $EDITOR $tmpname
    fileutil cp -f $tmpname $1
    rm $tmpname
  fi
}

function google3_footsteps() {
  if [[ $DIR_HISTFILE != '' ]]; then
    cat $DIR_HISTFILE | grep '/google/src/cloud/[a-z]*/[a-z_-]*/' \
      | sed 's:/google/src/cloud/[a-z]*/[a-z_-]*/google3/::' | sort -u
  fi
}

# edit after code search
function cse() {
  p4e $(cs $@)
}

# cd after code search
function csd() {
  g4cd $(cs $@)
}
