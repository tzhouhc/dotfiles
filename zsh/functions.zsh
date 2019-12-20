function zsh_reload() {
  source ~/.zshrc
}

function run() {
  /usr/bin/open $1
}

function unicode() {
  echo -e "\u$1"
}

function prompt_short_pwd() {
  res=$(short_pwd)
  root=$(echo $res | cut -d$'\n' -f 1)
  branch=$(echo $res | cut -d$'\n' -f 2)
  depth=$(echo $res | cut -d$'\n' -f 3)
  base=$(echo $res | cut -d$'\n' -f 4)

  if [[ $root == "/" ]]; then
    p10k segment -b red -f black -t ﮈ
  elif [[ $root == "~" ]]; then
    p10k segment -b springgreen4 -f black -t ﳐ
  else
    p10k segment -b grey23 -f orangered1 -t $root
  fi

  # this is to provide a little reminder of the overall
  # branch that we are currently in
  if [[ $branch != "" ]] && [[ $depth -ge 1 ]]; then
    if [[ $branch == "Documents" ]]; then
      branch_icon=" "
    elif [[ $branch == "Downloads" ]]; then
      branch_icon=" "
    elif [[ $branch == "Desktop" ]]; then
      branch_icon=" "
    elif [[ $branch == "Movies" ]]; then
      branch_icon="辶"
    elif [[ $branch == "Pictures" ]]; then
      branch_icon="辶"
    elif [[ $branch == "Library" ]]; then
      branch_icon=" "
    elif [[ $branch == "Music" ]]; then
      branch_icon=" "
    fi
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

function prompt_git_simple() {
  if is_git; then
    if git_dirty; then
      p10k segment -b yellow -f black -t "$(git_status)"
    else
      p10k segment -b green -f black -t "$(git_status)"
    fi
  fi
}

function prompt_small_status() {
  # shows last command success or failure (and exit code)
  if [[ $_p9k_status -eq 0 ]]; then
    p10k segment -b grey23 -f green -t ""
  else
    p10k segment -b grey23 -f red -t "$_p9k_status "
  fi
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
    pushd $(showmarks $1 | sed -e 's:\~:/Users/tingzhou:' | tr -d '\r') > /dev/null
    /usr/bin/open .
    popd 2>&1 > /dev/null
    hide_iterm_window
  }

  function open_and_switch() {
    /usr/bin/open $1
    hide_iterm_window
  }
fi

if [[ $IS_GOOGLE == 'true' ]]; then
  # jump to java test folder of the same package
  function jt() {
    if [[ $PWD =~ '(.*)/javatests(.*)' ]]; then
        cd "${match[1]}/java${match[2]}"
    else
        cd "${PWD/\/google3\/java//google3/javatests}"
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

  # mark for google3 -- disregard the workspace and go to short-path
  # this is needed over normal z since z no longer works if we change client
  function mark() {
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
      echo "https://source.corp.google.com/piper///depot/google3/$remainder"
    fi
  }

  # cd to specified short-path under the piper client
  function g4cd() {
    cd "$(g4pwd)/google3/$1"
  }

  # cd to current path but under blaze-bin instead
  function g4bin() {
    if g4pwd2 | grep blaze-bin > /dev/null; then
    else
      cd "$(g4pwd)/google3/blaze-bin/$(g4pwd2)"
    fi
  }

  # edit files that are open in the client
  function p4e() {
    set -o pipefail
    target="$(g4pwd)/google3/$(p4 p -l | grep depot --color=never | grep -v delete --color=never | sed 's/#[0-9]*//' | cut -d'/' -f5-10 | fzf | sed 's/ .*//')"
    if [ $? -eq 0 ]; then
      $EDITOR $target
    fi
  }
fi

