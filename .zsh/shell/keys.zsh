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
# option + left/right for also moving around words
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word
# meta + left/right for moving around words
bindkey '^[b' beginning-of-line
bindkey '^[f' end-of-line

function linewise_wrap_in_quotes() {
  # newline-wise split, then echo each individually
  for line in ${(f)1}; do
    echo -n "\"$line\" "
  done
}

# ---- some fzf functions with keyboard shortcuts

# TODO: currently widgets support completing based on partial path, but will
# not try to complete partial, *imcomplete* path, which I believe is fine --
# most of the time we will be using tab completed dir names anyway, if at all.

function my_fzf_global_dir_widget() {
  # clear redundant space
  # allow multiple selection
  maybedir=$(echo $LBUFFER | rev | cut -d' ' -f1 | rev)
  cleaned=$(echo $maybedir | sed "s:~:$HOME:")
  if [[ -d "$cleaned" ]]; then
    insert=$(global_dir_list "$cleaned")
    if [[ -n "$insert" ]]; then
      insert=$(linewise_wrap_in_quotes "$insert")
    fi
    LBUFFER="$(echo $LBUFFER | sed s:$maybedir:$insert:)"
  else
    insert=$(global_dir_list)
    if [[ -n "$insert" ]]; then
      insert=$(linewise_wrap_in_quotes "$insert")
    fi
    LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $insert"
  fi
  LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   my_fzf_global_dir_widget
bindkey '^[p' my_fzf_global_dir_widget

# customized version adds a space and removes unwanted files with fd
function my_fzf_file_widget() {
  # clear redundant space
  # allow multiple selection
  maybedir=$(echo $LBUFFER | rev | cut -d' ' -f1 | rev)
  cleaned=$(echo $maybedir | sed "s:~:$HOME:")
  if [[ -d "$cleaned" ]]; then
    insert=$(local_file_list "$cleaned")
    if [[ -n "$insert" ]]; then
      insert=$(linewise_wrap_in_quotes "$insert")
    fi
    LBUFFER="$(echo $LBUFFER | sed s:$maybedir:$insert:)"
  else
    insert=$(local_file_list)
    if [[ -n "$insert" ]]; then
      insert=$(linewise_wrap_in_quotes "$insert")
    fi
    LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $insert"
  fi
  LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   my_fzf_file_widget
bindkey '^o' my_fzf_file_widget

# unmapped -- doesn't seem to get enough use
function my_fzf_mru_file_widget() {
  # clear redundant space
  # allow multiple selection
  insert=$(vim_mru_list)
  if [[ -n "$insert" ]]; then
    insert=$(linewise_wrap_in_quotes "$insert")
  fi
  LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $insert"
  LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
  local ret=$?
  zle reset-prompt
  return $ret
}

function my_fzf_global_file_widget() {
  # clear redundant space
  # allow multiple selection
  insert=$(global_file_list)
  if [[ -n "$insert" ]]; then
    insert=$(linewise_wrap_in_quotes "$insert")
  fi
  LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $insert"
  LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   my_fzf_global_file_widget
bindkey '^[o' my_fzf_global_file_widget

function my-csearch-fzf-widget() {
  # Save the current buffer
  local buffer=$BUFFER
  # Clear the buffer
  BUFFER=""
  # Redisplay the prompt
  zle -R
  # Read user input
  echo -n "Enter search term: "
  read search_term
  # Perform the search and pipe to fzf
  local result=$(csearch "$search_term" | fzf --height 40% --reverse)
  # If a result was selected, append it to the buffer
  if [ -n "$result" ]; then
    result=$(echo $result | cut -d':' -f1)
    BUFFER="$buffer$result"
    # Move the cursor to the end of the buffer
    CURSOR=$#BUFFER
  else
    # If no result was selected, restore the original buffer
    BUFFER=$buffer
  fi
  # Redisplay the prompt
  zle -R
}
zle -N my-csearch-fzf-widget
# bindkey '^[f' my-csearch-fzf-widget


# Ctrl-f to run fuzzy search and return file name
function my_fzf_rg_widget() {
  insert=$(local_lines_list)
  if [[ -n "$insert" ]]; then
    insert=$(linewise_wrap_in_quotes "$insert")
  fi
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
    if [[ -n "$insert" ]]; then
      insert=$(linewise_wrap_in_quotes "$insert")
    fi
    LBUFFER="$(echo $LBUFFER | sed s:$maybedir:$insert:)"
  else
    insert=$(local_dir_list)
    if [[ -n "$insert" ]]; then
      insert=$(linewise_wrap_in_quotes "$insert")
    fi
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

function open_cmus_widget() {
  if [[ $TMUX != '' ]]; then
    # no actions required actually -- this is a tmux keybind
  elif [[ $ZELLIJ != '' ]]; then
    if [[ -n "$(ps | grep screen | grep -v grep)" ]]; then
      return
    fi
    zellij run -f -c -- screen -q -r -D cmus || screen -S cmus "$actual"
  fi
}
# -- This feature is now done inside of zellij directly; we leave it here
# as a record.
# zle     -N    open_cmus_widget
# bindkey '^[m' open_cmus_widget

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

bindkey -s '^y' "yazi^M"
