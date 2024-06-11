bindkey -e

# bindkey to see available actions
# bindkey -L to see current mappings

# ---- custom mappings
# up/down key for history search
bindkey '[A' history-beginning-search-backward
bindkey '[B' history-beginning-search-forward
# ctrl + left/right for moving around words
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
# meta + left/right for moving around words
bindkey '^[b' beginning-of-line
bindkey '^[f' end-of-line


# ---- some fzf functions with keyboard shortcuts

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

# Meta-O to write recent files to the zle
function my_fzf_mru_file_widget() {
  # clear redundant space
  # allow multiple selection
  # TODO: allow spaces in paths
  insert=$(vim_mru_list)
  LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $insert"
  LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   my_fzf_mru_file_widget
bindkey '^[o' my_fzf_mru_file_widget


# Ctrl-f to run fuzzy search and return file name
function my_fzf_rg_widget() {
  insert=$(local_lines_list)
  LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $insert"
  LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   my_fzf_rg_widget
bindkey '^f' my_fzf_rg_widget

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

autoload edit-command-line; zle -N edit-command-line
bindkey '^z' edit-command-line

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

zle -N pipe_to_less
bindkey "^[e" pipe_to_less
