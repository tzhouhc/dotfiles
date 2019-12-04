function zsh_reload() {
  source ~/.zshrc
}

function run() {
  /usr/bin/open $1
}


function relative_root() {
  if [[ $PWD =~ '/google/src/cloud/[^/]+/([^/]+)/?(.*)' ]]; then
    print -r -- $match[1]
  elif [[ $PWD =~ "$HOME(.*)" ]]; then
    print -r -- "~"
  else
    print -r -- "/"
  fi
}

function prompt_relative_root() {
  root=$(relative_root)
  if [[ $PROMPT_STYLE == 'lean' ]]; then
    if [[ $root == "/" ]]; then
      p10k segment -f red -t $root
    elif [[ $root == "~" ]]; then
      p10k segment -f springgreen4 -t $root
    else
      p10k segment -f orangered1 -t $root
    fi
  else
    if [[ $root == "/" ]]; then
      p10k segment -b red -f black -t $root
    elif [[ $root == "~" ]]; then
      p10k segment -b springgreen4 -f black -t $root
    else
      p10k segment -b grey23 -f orangered1 -t $root
    fi
  fi
}

function relative_depth_with_zero() {
  if [[ $PWD =~ '/google/src/cloud/[^/]+/([^/]+)/?(.*)' ]]; then
    depth=$(echo ${match[2]} | awk -F"/" '{print NF-1}')
  elif [[ $PWD =~ "$HOME(.*)" ]]; then
    depth=$(echo ${match[1]} | awk -F"/" '{print NF-2}')
  elif [[ $PWD == '/' ]]; then
    depth=-1
  else
    depth=$(echo $PWD | awk -F"/" '{print NF-2}')
  fi
  print -r -- $depth
}

function relative_depth() {
  depth=$(relative_depth_with_zero)
  if [[ $depth -ge 1 ]]; then
    print -r -- $depth
  fi
}

function prompt_relative_depth() {
  rel_depth=$(relative_depth)
  if [[ -n $rel_depth ]]; then
    if [[ $PROMPT_STYLE == 'lean' ]]; then
      p10k segment -f khaki1 -t $rel_depth
    else
      p10k segment -b khaki1 -f black -t $rel_depth
    fi
  fi
}

function current_dir() {
  if [[ $(relative_depth_with_zero) -ge 0 ]]; then
    print -r -- $(basename $(pwd))
  fi
}

function prompt_current_dir() {
  if [[ $PROMPT_STYLE == 'lean' ]]; then
    p10k segment -f skyblue1 -t "$(current_dir)"
  else
    p10k segment -b skyblue1 -f black -t "$(current_dir)"
  fi
}

function prompt_small_status() {
  # shows last command success or failure (and exit code)
  if [[ $_p9k_status -eq 0 ]]; then
    p10k segment -b grey23 -f green -t "="
  else
    p10k segment -b grey23 -f red -t "$_p9k_status"
  fi
}

# customized prompt
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

function git_inside_repo() {
  print "$(git rev-parse --is-inside-work-tree 2>/dev/null)"
}

function git_position() {
  if [[ -n $(git status | grep ahead) ]]; then
    print -rn -- ">"
  elif [[ -n $(git status | grep behind) ]]; then
    print -rn -- "<"
  else
  fi
}

function git_branch() {
  print -rn -- "$(git rev-parse --abbrev-ref HEAD)"
}

function git_dirty() {
  if [[ $(git diff --stat) != '' ]]; then
    print -rn -- "≠"
  else
  fi
}

function git_prompt() {
  if [ "$(git_inside_repo)" ]; then
    print -rn -- "%F{cyan}($(git_branch)%F{red}$(git_dirty)$(git_position)%f)"
  fi
}

function prompt_git_simple() {
  if [[ "$(git_inside_repo)" ]]; then
    branch_status="$(git_branch) $(git_dirty)"
    if [[ $(git_position) == ">" ]]; then
      p10k segment -b wheat1 -f black -t $branch_status
    elif [[ $(git_position) == "<" ]]; then
      p10k segment -b orange4 -f black -t $branch_status
    else
      p10k segment -b green -f black -t $branch_status
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

if type fd > /dev/null; then
  _fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
  }
  _fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
  }
fi


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

  function bbs() {
    # build, then go to the blaze-out directory
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
fi
