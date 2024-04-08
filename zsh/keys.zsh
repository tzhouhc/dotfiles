# up/down key for history search
bindkey -e
bindkey '[A' history-beginning-search-backward
bindkey '[B' history-beginning-search-forward

# Ctrl-n to list available blaze build targets
function my_BUILD_widget() {
  if [[ -f BUILD ]]; then
    insert=$(build_target_list)
    LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $insert"
    LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
    local ret=$?
    zle reset-prompt
    return $ret
  else
    echo "No BUILD file found."
    zle reset-prompt
    return
  fi
}
zle     -N   my_BUILD_widget
bindkey '^n' my_BUILD_widget

# Meta-n to list available blaze test targets
function my_BUILD_test_widget() {
  if [[ -f BUILD ]]; then
    insert=$(build_test_target_list)
    LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $insert"
    LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
    local ret=$?
    zle reset-prompt
    return $ret
  else
    echo "No BUILD file found."
    zle reset-prompt
    return
  fi
}
zle     -N   my_BUILD_test_widget
bindkey '^[n' my_BUILD_test_widget

# Ctrl-o to write local files to the zle
# customized version adds a space and removes unwanted files with fd
function my_fzf_file_widget() {
  # clear redundant space
  # allow multiple selection
  # TODO: allow spaces in paths
  maybedir=$(echo $LBUFFER | rev | cut -d' ' -f1 | rev)
  cleaned=$(echo $maybedir | sed "s:~:$HOME:")
  if [[ -d "$cleaned" ]]; then
    insert=$(local_file_list "$cleaned")
    LBUFFER="$(echo $LBUFFER | sed s:$maybedir:$insert:)"
  else
    insert=$(local_file_list)
    LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $insert"
  fi
  LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   my_fzf_file_widget
bindkey '^o' my_fzf_file_widget

# Meta-o to open changed files in current version control system
function my_p4_change_widget() {
  insert=$(p4_change_list)
  LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $insert"
  LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   my_p4_change_widget
bindkey '^[o' my_p4_change_widget

# Ctrl-f to run fuzzy search and return file name
function my_fzf_ag_widget() {
  insert=$(local_lines_list)
  LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $insert"
  LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   my_fzf_ag_widget
bindkey '^f' my_fzf_ag_widget

# Meta-f to fuzzy search for line and jump to view in less
function my_fzf_ag_num_widget() {
  tuple=$(local_lines_list_with_num)
  if [[ ! -z $tuple ]]; then
    file=$(echo $tuple | cut -d':' -f1)
    line=$(echo $tuple | cut -d':' -f2)
    bat --pager "less +${line}g" "${file}"
  fi
  zle reset-prompt
}
zle     -N   my_fzf_ag_num_widget
bindkey '^[f' my_fzf_ag_num_widget

# Ctrl-v to fuzzy-search for lines and edit
function my_vim_edit_num_widget() {
  tuple=$(local_lines_list_with_num)
  if [[ ! -z $tuple ]]; then
    file=$(echo $tuple | cut -d':' -f1)
    line=$(echo $tuple | cut -d':' -f2)
    vim $file +$line
  fi
  zle reset-prompt
}
zle     -N   my_vim_edit_num_widget
bindkey '^v' my_vim_edit_num_widget

# Meta-v to edit changed files in current version control system
function my_vim_edit_change_widget() {
  files=$(p4_change_list)
  if [[ ! -z $files ]]; then
    vim $(echo $files)  # I don't really understand this...
  fi
  zle reset-prompt
}
zle     -N   my_vim_edit_change_widget
bindkey '^[v' my_vim_edit_change_widget

# Ctrl-p to write local folders to the zle
function my_fzf_folder_widget() {
  # clear redundant space
  # allow multiple selection
  maybedir=$(echo $LBUFFER | rev | cut -d' ' -f1 | rev)
  cleaned=$(echo $maybedir | sed "s:~:$HOME:")
  if [[ -d "$cleaned" ]]; then
    insert=$(local_dir_list "$cleaned")
    LBUFFER="$(echo $LBUFFER | sed s:$maybedir:$insert:)"
  else
    insert=$(local_dir_list)
    LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $insert"
  fi
  LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   my_fzf_folder_widget
bindkey '^p' my_fzf_folder_widget

# Meta-p to open recently accessed folders
# use z's history for recently-accessed directories
function my_mru_dir() {
  choice=$(z_mru_dir_list)
  LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $choice"
  LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   my_mru_dir
bindkey '^[p' my_mru_dir

# Ctrl-v to edit line in vim (with auto cursor positioning and insert mode)
# ALSO FMI: `fc` opens the last command in $EDITOR
function edit_line_in_vim() {
  tmpf=$(mktemp)
  echo $BUFFER > $tmpf
  # jump to end of file and insert at end of line
  lvim -s <(printf 'GA') +'set ft=sh' $tmpf
  BUFFER=$(cat $tmpf)
  rm -f $tmpf
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   edit_line_in_vim
bindkey '^z' edit_line_in_vim

# Opt-v to list pasteboard content
function get_pasteboard() {
  content=$(pbpaste | fzf)
  BUFFER="$LBUFFER$content"
  rm -f $content
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   get_pasteboard
bindkey '^[v' get_pasteboard

# Meta-k to open command shorthands
# 'navi' backwards
# Utilities to quickly insert snippets into current line
# Snippets use the same format as navi(denisidoro/navi)'s cheat files
function ivan() {
  snip=$(ivan_snippet_list)
  LBUFFER="$LBUFFER$snip"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   ivan
bindkey '^[k' ivan

# context-aware history -- automatically determines if it should use p4 variant
# or base variant
function dir_history() {
  if [[ $(g4pwd) != "" ]]; then
    snip=$(p4_dir_ctx_command_list)
  else
    snip=$(dir_ctx_command_list)
  fi
  LBUFFER="$LBUFFER$snip"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   dir_history
bindkey '^y' dir_history

# Ctrl-g to list git commits
function git_commits() {
  choice=$(git_commit_list)
  LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $choice"
  LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   git_commits
bindkey '^g' git_commits

# Ctrl-k to list ALL available fzf handlers.
# One function that provides all available fzf lists
function superfzf() {
  choice=$(all_fzf_list)
  LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $choice"
  LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   superfzf
bindkey '^k' superfzf
