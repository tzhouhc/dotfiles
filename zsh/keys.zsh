# up/down key for history search
bindkey -e
bindkey '[A' history-beginning-search-backward
bindkey '[B' history-beginning-search-forward

function my-BUILD-widget() {
  if [[ -f BUILD ]]; then
    insert=$(build-target-list)
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
zle     -N   my-BUILD-widget
bindkey '^n' my-BUILD-widget

# Ctrl-o to write local files to the zle
# customized version adds a space and removes unwanted files with fd
function my-fzf-file-widget() {
  # clear redundant space
  # allow multiple selection
  insert=$(local-file-list)
  LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $insert"
  LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   my-fzf-file-widget
bindkey '^o' my-fzf-file-widget

# Ctrl-h to run ag non-fuzzily and open selected file by content
function my-fzf-ag-exact-widget() {
  insert=$(local-lines-exact-list)
  LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $insert"
  LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   my-fzf-ag-exact-widget
bindkey '^f' my-fzf-ag-exact-widget

# Ctrl-i to write local folders to the zle
function my-fzf-folder-widget() {
  # clear redundant space
  # allow multiple selection
  LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $(local-dir-list)"
  LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   my-fzf-folder-widget
bindkey '^p' my-fzf-folder-widget

# Ctrl-v to edit line in vim (with auto cursor positioning and insert mode)
# ALSO FMI: `fc` opens the last command in $EDITOR
function edit-line-in-vim() {
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
zle     -N   edit-line-in-vim
bindkey '^v' edit-line-in-vim

# use z's history for recently-accessed directories
function my-mru-dir() {
  choice=$(mru-dir-list)
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
  snip=$(ivan-list)
  LBUFFER="$LBUFFER$snip"
  local ret=$?
  zle reset-prompt
  return $ret
}
# zle     -N   ivan
# bindkey '^g' ivan

# One function that provides all available fzf lists
function superfzf() {
  choice=$(all-fzf-list)
  LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $choice"
  LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   superfzf
bindkey '^k' superfzf
