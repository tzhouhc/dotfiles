# up/down key for history search
bindkey -e
bindkey '[A' history-beginning-search-backward
bindkey '[B' history-beginning-search-forward

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

# Ctrl-h to run ag non-fuzzily and open selected file by content
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
bindkey '^e' my_fzf_ag_num_widget

# Ctrl-i to write local folders to the zle
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
bindkey '^v' edit_line_in_vim

# use z's history for recently-accessed directories
function my_mru_dir() {
  choice=$(z_mru_dir_list)
  LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $choice"
  LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
  local ret=$?
  zle reset-prompt
  return $ret
}
# zle     -N   my-mru-dir
# bindkey '^k' my-mru-dir

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
bindkey '^g' ivan

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
