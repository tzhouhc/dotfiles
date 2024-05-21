# old functions that have since been deprecated
#
# Kept for archival purposes (yes I know that's what git does for me anyway)

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

function get_workspace() {
  res=$(short_pwd)
  root=$(echo $res | cut -d$'\n' -f 1)
  printf $root
}

function git_dirty() {
  if git diff --quiet; then
    return 1
  else
    return 0
  fi
}

function is_p4() {
  if [[ $(pwd) == /google/src/cloud/tingzhou/* ]]; then
    return 0
  else
    return 1
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

function hg_branch() {
  branch=$(hg branch 2>&1)
  if [[ $? -eq 0 ]]; then
    print -rn -- "[%F{magenta}$(hg prompt '{branch}{status}')%f] "
  else
    print -rn -- " "
  fi
}

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

function critical_role_by_script() {
  pushd $CRITICAL_ROLE_PATH > /dev/null 2>&1
  cat ./* | fzf -m -d"\t" --exact --with-nth 2 --preview='ln={5}; sed -n $ln,$[$ln + 50]p {4} | cut -f1,2' | cut -d$'\t' -f3
  popd > /dev/null 2>&1
}

function batrange() {
  print $[$[$1 - 3] < 0 ? 0 : $[$1 - 3]]:$[$ln + 20]
}
