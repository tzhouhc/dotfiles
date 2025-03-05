# This contains the set of commandline functions that condenses the most
# commonly used functionalities in the shell using the 26 letters.
#
# Currently not all letters are occupied.

# function a() {
# }

# Configs
# Choose and Edit all config files
function c() {
  binding='enter:become(supervim {})'
  fd . $HOME/.dotfiles | fzf --query="$@" --preview="smart_preview {}" --bind="$binding"
}

# Edit
# Open any recent files by this name in supervim
function e() {
  hist_file="$HOME/.data/edit_history"
  if ! [[ -f "$hist_file" ]]; then
    touch "$hist_file"
  fi
  if [[ -f "$1" ]]; then
    echo $(readlink -f "$1") >> "$hist_file"
    sort "$hist_file" | uniq -u | sponge "$hist_file"
    supervim "$1"
    return
  fi
  if res=$(cat "$hist_file" | fzf --preview='smart_preview {}'); then
    if ! [[ -f "$res" ]]; then
      echo "File '$res' not found."
      grep -v "$res" "$hist_file" | sponge "$hist_file"
      return
    fi
    supervim "$res"
  fi
}

# Find
# Searches local files via fzf and
#   - prints file name on Enter
#   - opens to selected line for edit on ctrl-E
#   - opens in bat on ctrl-L
#   - opens containing directory on ctrl-O
# key used for pay-respect instead

# function f() {
#   preview='ln={2}; bat {1} -H $ln -r $[$[$ln - 3] < 0 ? 0 : $[$ln - 3]]:'
#   rg --no-heading --no-context-separator . | \
#   fzf --ansi -d':' -n3.. --preview="$preview" \
#     --bind 'enter:become(print {1})' \
#     --bind 'ctrl-e:become(supervim +{2} {1})' \
#     --bind 'ctrl-l:become(bat {1} -H {2})' \
#     --bind 'ctrl-o:become(open -R {1})'
# }

# Git
# function g() is an alias to git

# Just
# function j() is an alias to just

# List
# function l() is an alias to exa

# Open
# Open a directory by either direct naming or zoxide reference if given a name.
# Otherwise, open a selector for either files or directories.
# Reasoning being it's harder and requires more precision to find a file
# by name.
function o() {
  if [[ $1 != '' ]]; then
    cwd=$(pwd)
    smart_cd $1
    /usr/bin/open .
    cd $cwd
    if uname -a | grep -i darwin > /dev/null; then
      hide_iterm_window
    fi
    return
  fi
  binding='enter:become(open {}),ctrl-o:become(open -R {})'
  result=$( ( fd . --hidden ~/ & fd . "/Applications/" --extension app ) | fzf --bind "$binding" )
  if [[ "$result" != '' ]]; then
    open $result
  fi
}

# Vim
# function v() is an alias to supervim

# Which
# Edit the source of an commandline runnable.
function w() {
  t=$(type "$1")
  # if type fails, runnable doesn't exist
  if [[ $? != 0 ]]; then
    return
  fi
  # this _might_ be a file path
  f=$(echo $t | choose -1)
  if echo $t | grep 'shell builtin' >& /dev/null; then
    echo $t
  elif echo $t | grep 'alias' >& /dev/null; then
    # assumes all aliases are in the main alias file.
    supervim $ZSH_HOME/shell/aliases.zsh
  # if file exists and is a text file (i.e. script)
  elif [[ -f "$f" ]] && file "$f" | grep -Eq 'text$'; then
    supervim "$f"
  fi
}

# Zoxide
# function z() already defined via zoxide

