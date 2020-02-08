# Recently visited directories in current shell session
function local-recent-dir-list() {
  if [[ -n $1 ]]
  then
    dirs "$@"
  else
    print "$(dirs -v | cut -f2 | fzf | sed s:~:$HOME:)"
  fi
}

# Current Citc client changed files
function p4-change-list() {
  print "$(g4pwd)/$(p4 p -l | grep depot --color=never | grep -v delete --color=never | sed 's/#[0-9]*//' | cut -d'/' -f4- | fzf | sed 's/ .*//')"
}

# Notable citc package paths
function p4-package-list() {
  print $(echo "Alias\tG3path\n$(cat ~/.g3marks)" | column -t | fzf --header-lines=1 | grep -o "[^ ]*$")
}

# Build targets visible in the current directory
function build-target-list() {
  print $(cat BUILD | egrep '^\s+name \=' | sed "s/^[^\"]*\"//" | sed "s/\".*$//" | fzf)
}

# Files visible in the current directory
function local-file-list() {
  print "$(fd . -H --type f | fzf -m --preview 'bat {}' | sed 's/\(.*\)/\"\1\"/g' | paste -sd ' ')"
}

# Lines in files visible in the current directory
function local-lines-list() {
  print "$(ag --nobreak --noheading . | fzf -m --exact -d':' --preview 'ln={2}; bat {1} -H $ln -r $[$[$ln - 3] < 0 ? 0 : $[$ln - 3]]:' | cut -d':' -f1 | sed 's/\(.*\)/\"\1\"/g' | paste -sd ' ')"
}

# Lines (matching exactly) in files visible in the current directory
function local-lines-exact-list() {
  print "$(ag --nobreak --noheading . | fzf -m --exact -d':' --preview 'ln={2}; bat {1} -H $ln -r $[$[$ln - 3] < 0 ? 0 : $[$ln - 3]]:' | cut -d':' -f1 | sed 's/\(.*\)/\"\1\"/g' | paste -sd ' ')"
}

# Directories visible in the current directory
function local-dir-list() {
  print $(fd . -L -H --type d | fzf -m | sed 's/\(.*\)/\"\1\"/g')
}

# Recently visited directories as per z's record
function z-mru-dir-list() {
  print $(cat $HOME/.z | sort -n -t'|' -k 2 -r | cut -d'|' -f1 | fzf)
}

# Helpful shell snippets
function ivan-snippet-list() {
  print $(cat ~/.dotfiles/zsh/navi/* | egrep -v '^(%.*)?$' \
    | sed '$!N;s/\n/ # /' | sed 's/^#//' \
    | fzf -d'#' --with-nth=1 --preview 'echo {2}' --nth=2 \
    | cut -d'#' -f2 | sed 's/^ *//')
}

# Current processes; return the PID
function process-name-list() {
  print $(ps -aeo uid,pid,command | fzf --header-lines=1 | cut -d' ' -f4)
}

# Current Git repo commit history
function git-commit-list() {
  print $(git log --pretty=oneline --abbrev-commit | fzf --preview 'echo {} | cut -f 1 -d " " | xargs git show --color=always' | cut -f 1 -d " ")
}

# Function that collect all above method names and help messages for fzf
function all-fzf-list() {
  funcs=("${(f)$(cat ~/.zsh/fzf.zsh | grep 'function' -B 1 | head -n -7 | grep -v '^\-\-' | paste -d'#' - -)}")
  res=("Method                           Details")
  for line in $funcs; do
    comment=$(echo $line | grep -oP "(?<=# )[\w\s]+")
    func=$(echo $line | grep -oP "(?<=function )[\w-]+")
    res+=("$(printf "%-30s %s\n" $func): $comment")
  done
  print $($(print -l $res | fzf --header-lines=1 | cut -d':' -f1))
}
