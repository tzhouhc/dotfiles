# Source FZF if available
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# this makes it so fzf won't go searching for files in gitignore paths
if type fd > /dev/null; then
  _fzf_compgen_path() {
    fd --follow --exclude ".git" . "$1"
  }
  _fzf_compgen_dir() {
    fd --type d --follow --exclude ".git" . "$1"
  }
fi

# Recently visited directories in current shell session
function local_recent_dir_list() {
  if [[ -n $1 ]]
  then
    dirs "$@"
  else
    print "$(dirs -v | cut -f2 | fzf | sed s:~:$HOME:)"
  fi
}

function global_dir_list() {
  res=$(fd -t d . / | fzfp -m)
  print "$res"
}

# This takes up wayyy too much time for a quick searching tool
function global_file_list() {
  res=$(fd -t f . / | fzfp -m)
  print "$res"
}

# Recently edited files based on neovim
function vim_mru_list() {
  res=$(nvim --headless -c "lua for _,file in ipairs(vim.v.oldfiles) do print(file) end" -c "q" 2>&1 | grep -v "^$" | sed 's/.$//' | uniq | fzfp -m)
  print $res
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

# Files visible in the current directory
function local_file_list() {
  if [[ $1 != '' ]]; then
    # note: used to do `sort` in the middle as well -- apparently it doesn't
    # work with with filenames that have spaces
    print "$(fd . --type f --type l $1 | fzfp -m)"
  else
    print "$(fd . --type f --type l | fzfp -m)"
  fi
}

# All files in dotfiles.git repo
function dotfiles_list() {
  print "$(git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME ls-files $HOME --full-name \
    | fzfp -m | sed s:^:$HOME/:)"
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

fzf_preview='ln={2}; bat {1} -H $ln -r $[$[$ln - 3] < 0 ? 0 : $[$ln - 3]]:'

# Lines in files visible in the current directory
function local_lines_list() {
  print "$(rg --no-heading --no-context-separator . 2>/dev/null | fzf -m --ansi -d':' -n3.. --preview $fzf_preview | cut -d':' -f1)"
}

# Lines (matching exactly) in files visible in the current directory
function local_lines_exact_list() {
  print "$(rg --no-heading --no-context-separator . 2>/dev/null | fzf -m --ansi --exact -d':' -n3.. --preview $fzf_preview | cut -d':' -f1)"
}

# Lines (matching exactly) in files visible in the current directory with line numbers
function local_lines_list_with_num() {
  print "$(rg --no-heading --no-context-separator . 2>/dev/null | fzf -m --ansi -d':' --preview $fzf_preview | cut -d':' -f1,2 | paste -sd ' ')"
}

# Directories visible in the current directory
function local_dir_list() {
  if [[ $1 != '' ]]; then
    print "$(fd . -L --type d $1 | fzfp -m)"
  else
    print "$(fd . -L --type d | fzfp -m)"
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
# DEPRECATED: decided to move from shell impl to zoxide, which now makes this
# not quite work
function z_mru_dir_list() {
  print "$(cat $HOME/.z | sort -n -t'|' -k 2 -r | cut -d'|' -f1 | fzf)"
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
  echo "Bin\tPath\n$(whence -pm '*' | sed "s/([a-zA-Z0-9_.-]*)$/\1 \1/" | awk '{ print $2 " " $1}')" | column -t | fzf --header-lines=1 "$@" | grep -o '[^ ]*$'
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

# Current Git repo commit history
function git_commit_list() {
  git log --graph --color=always \
          --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" | \
    fzf --ansi --preview 'echo {} | cut -f 1 -d " " | xargs git show --color=always' | cut -f 2 -d " "
}

# Everything
function everything_list() {
  fd . $HOME | fzf | sed 's/(.*)/\"\1\"/g'
}

# Function that collect all above method names and help messages for fzf
# WARN: NOT PRACTICAL
function all_fzf_list() {
  funcs=("${(f)$(cat ~/.zsh/lib/fzf.zsh | grep 'function' -B 1 | head -n -7 | grep -v '^--' | paste -d'#' - -)}")
  res=("Method                           Details")
  for line in $funcs; do
    comment=$(echo $line | grep -oP "(?<=# )[\w\s]+")
    func=$(echo $line | grep -oP "(?<=function )[\w-]+")
    res+=("$(printf "%-30s %s\n" $func): $comment")
  done
  print $($(print -l $res | fzf --header-lines=1 | cut -d':' -f1))
}

function csearch_list() {
  echo -n "Enter search term: "
  read search_term
  # Perform the search and pipe to fzf
  partial=$(csearch $search_term)
  result=$(echo $partial | fzf --height 40% --reverse)
  file=$(echo $result | cut -d':' -f1)
  print ${result}
}
