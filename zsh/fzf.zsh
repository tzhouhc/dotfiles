# Recently visited directories in current shell session
function local_recent_dir_list() {
  if [[ -n $1 ]]
  then
    dirs "$@"
  else
    print "$(dirs -v | cut -f2 | fzf | sed s:~:$HOME: | sed 's/(.*)/\"\1\"/g')"
  fi
}

# Current Citc client changed files; also handles git
function p4_change_list() {
  if is_git ; then
    print "$(git ls-files -m | fzf -m | tr '\n' ' ')"
  elif is_p4 ; then
    print "$(p4 p -l | grep depot --color=never | egrep -v delete$ --color=never | sed 's/#[0-9]*//' | cut -d'/' -f4- | fzf -m | sed 's/ .*//' | sed s:^:$(g4pwd)/: | tr '\n' ' ')"
  fi
}

# Current Citc client changed files, including deletions; also handles git
function p4_full_change_list() {
  if is_git ; then
    print "$(git ls-files -m | fzf -m | tr '\n' ' ')"
  elif is_p4 ; then
    print "$(p4 p -l | grep depot --color=never | sed 's/#[0-9]*//' | cut -d'/' -f4- | fzf -m | sed 's/ .*//' | sed s:^:$(g4pwd)/: | tr '\n' ' ')"
  fi
}

# Notable citc package paths
function p4_package_list() {
  print $(echo "Alias\tG3path\n$(cat ~/.g3marks)" | column -t | fzf --header-lines=1 | grep -o "[^ ]*$")
}

# Build targets visible in the current directory
function build_target_list() {
  print $(cat BUILD | egrep '^\s+name \=' | sed "s/^[^\"]*\"//" | sed "s/\".*$//" | fzf)
}

# Build targets visible in the current directory
function build_test_target_list() {
  print $(cat BUILD | egrep '^\s+name \=' | grep 'test' | sed "s/^[^\"]*\"//" | sed "s/\".*$//" | fzf)
}

# Files visible in the current directory
function local_file_list() {
  if [[ $1 != '' ]]; then
    print "$(fd . -H --type f $1 | sort | fzf -m --preview 'bat {}' | sed 's/(.*)/\"\1\"/g' | paste -sd ' ')"
  else
    print "$(fd . -H --type f | sort | fzf -m --preview 'bat {}' | sed 's/(.*)/\"\1\"/g' | paste -sd ' ')"
  fi
}

function homebrew_formula_list() {
  brew search | fzf -m
}

# Ctags visible in the current directory level (non-recursive)
function local_tag_list() {
  echo "Tag\tFile\tLine\n$(fd . -d 1 | ctags -L- -f- | cut -d$'\t' -f1,2,5)" \
    | column -t -s $'\t' | sed $'s/ \([^ ]\)/\u00a0\\1/g' \
    | fzf --header-lines=1 -d$'\u00a0' --nth=1 \
    | awk -F $'\u00a0' '{print $2}'
}

# Lines in files visible in the current directory
function local_lines_list() {
  print "$(ag --nobreak --noheading . | fzf -m -d':' -n3 --preview 'ln={2}; bat {1} -H $ln -r $[$[$ln - 3] < 0 ? 0 : $[$ln - 3]]:' | cut -d':' -f1 | sed 's/(.*)/\"\1\"/g' | paste -sd ' ')"
}

# Lines (matching exactly) in files visible in the current directory
function local_lines_exact_list() {
  print "$(ag --nobreak --noheading . | fzf -m --exact -d':' -n3 --preview 'ln={2}; bat {1} -H $ln -r $[$[$ln - 3] < 0 ? 0 : $[$ln - 3]]:' | cut -d':' -f1 | sed 's/(.*)/\"\1\"/g' | paste -sd ' ')"
}

# Lines (matching exactly) in files visible in the current directory with line numbers
function local_lines_list_with_num() {
  print "$(ag --nobreak --noheading . | fzf -m -d':' --preview 'ln={2}; bat {1} -H $ln -r $[$[$ln - 3] < 0 ? 0 : $[$ln - 3]]:' | cut -d':' -f1,2 | paste -sd ' ')"
}

# Directories visible in the current directory
function local_dir_list() {
  if [[ $1 != '' ]]; then
    print "$(fd . -L -H --type d $1 | fzf -m --preview 'ls --color=always {}' | sed 's/(.*)/\"\1\"/g')"
  else
    print "$(fd . -L -H --type d | fzf -m --preview 'ls --color=always {}' | sed 's/(.*)/\"\1\"/g')"
  fi
}

# Dictionary English words
function english_word_list() {
  if type wn >/dev/null 2>&1; then
    print $(cat /usr/share/dict/words | fzf --preview-window=right:wrap --preview 'wn {1} -over')
  elif type dict >/dev/null 2>&1; then
    print $(cat /usr/share/dict/words | fzf --preview-window=right:wrap --preview 'dict -f {1}')
  else
    print $(cat /usr/share/dict/words | fzf)
  fi
}
# Recently visited directories as per z's record
function z_mru_dir_list() {
  print "$(cat $HOME/.z | sort -n -t'|' -k 2 -r | cut -d'|' -f1 | fzf | sed 's/(.*)/\"\1\"/g')"
}

# Helpful shell snippets
function ivan_snippet_list() {
  line=$(cat ~/.dotfiles/zsh/navi/* | egrep -v '^(%.*)?$' \
    | sed '$!N;s/\n/ # /' | sed 's/^#//' \
    | fzf -d'#' --with-nth=1 --preview 'echo {2}' \
    | cut -d'#' -f2 | sed 's/^ *//')
  print -- $(populate_tags $line)
}

# Current processes; return the PID
function process_name_list() {
  ps -aeo uid,pid,command | fzf --header-lines=1 | tr -s ' ' | cut -d' ' -f2
}

# Environment variables
function env_var_list() {
  print \$$(echo "Env=Value\n$(env)" | column -s'=' -t 2>/dev/null | fzf --header-lines=1 | cut -d' ' -f1)
}

# Executable binaries
function bin_list() {
  echo "Bin\tPath\n$(whence -pm '*' | sed "s/([a-zA-Z0-9_.-]*)$/\1 \1/" | awk '{ print $2 " " $1}')" | column -t | fzf --header-lines=1 | grep -o '[^ ]*$'
}

# Directory-context-aware command history (enable by setting DIR_AWARE_HISTFILE)
function dir_ctx_command_list() {
  print $(cat $DIR_AWARE_HISTFILE | grep "$PWD#" | cut -d'#' -f2- | fzf)
}

# P4-package-context-aware command history (enable by setting DIR_AWARE_HISTFILE)
function p4_dir_ctx_command_list() {
  g4pwd=$(g4pwd2)
  if [[ $g4pwd != '' ]]; then
    print $(cat $DIR_AWARE_HISTFILE | grep "$g4pwd#" | cut -d'#' -f2- | fzf)
  fi
}

# ALL google3 build targets in folders with footsteps (i.e. visited and actions performed)
function p4_footstep_build_target_list() {
  for line in $(google3_footsteps); do
    if [[ -f "$(g4pwd)/google3/$line/BUILD" ]]; then
      targets=$(ctags --language-force=bzl -f - "$(g4pwd)/google3/$line/BUILD" | cut -d$'\t' -f1 | sed "s:^://$line\::")
      targetlist="$targetlist\n$targets"
    fi
  done
  echo $targetlist | fzf
}

# Search CS and return result
function cs() {
  if [[ -n $1 ]]; then
    /usr/bin/cs $@ 2>/dev/null | \
      fzf -d':' --with-nth=1 --preview 'ln={2}; bat {1} -r $[$[$ln - 3] < 0 ? 0 : $[$ln - 3]]:' | \
      cut -d':' -f1 | cut -d'/' -f7-
  else
    /usr/bin/cs
  fi
}

# CD after searching through CS
function cscd() {
  if [[ -n $1 ]]; then
    res=$(cs $@)
    if [[ -n $res ]]; then
      echo $res
      g4cd $(echo $res | cut -d'/' -f8-)
    fi
  fi
}

# Current Git repo commit history
function git_commit_list() {
  git log --graph --color=always \
          --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" | \
    fzf --ansi --preview 'echo {} | cut -f 1 -d " " | xargs git show --color=always' | cut -f 2 -d " "
}

# Everything
function everything_list() {
  fd . $HOME -H | fzf | sed 's/(.*)/\"\1\"/g'
}

# Function that collect all above method names and help messages for fzf
function all_fzf_list() {
  funcs=("${(f)$(cat ~/.zsh/fzf.zsh | grep 'function' -B 1 | head -n -7 | grep -v '^--' | paste -d'#' - -)}")
  res=("Method                           Details")
  for line in $funcs; do
    comment=$(echo $line | grep -oP "(?<=# )[\w\s]+")
    func=$(echo $line | grep -oP "(?<=function )[\w-]+")
    res+=("$(printf "%-30s %s\n" $func): $comment")
  done
  print $($(print -l $res | fzf --header-lines=1 | cut -d':' -f1))
}
