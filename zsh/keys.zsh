# up/down key for history search
bindkey -e
bindkey '[A' history-beginning-search-backward
bindkey '[B' history-beginning-search-forward



# Ctrl-o to write local files to the zle
# customized version adds a space and removes unwanted files with fd
function my-fzf-file-widget() {
  # clear redundant space
  # allow multiple selection
  insert="$(fd . --type f | fzf -m --preview 'bat {}' | sed 's/\(.*\)/\"\1\"/g' | paste -sd ' ')"
  LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $insert"
  LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   my-fzf-file-widget
bindkey '^o' my-fzf-file-widget

# Ctrl-F to run ag non-fuzzily and open selected file by content
function my-fzf-ag-exact-widget() {
  insert="$(ag --nobreak --noheading . | fzf -m --exact -d':' --preview 'ln={2}; bat {1} -H $ln -r $[$[$ln - 3] < 0 ? 0 : $[$ln - 3]]:' | cut -d':' -f1 | sed 's/\(.*\)/\"\1\"/g' | paste -sd ' ')"
  LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $insert"
  LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   my-fzf-ag-exact-widget
bindkey '^h' my-fzf-ag-exact-widget

# Ctrl-f to run ag and open selected file by content
function my-fzf-ag-widget() {
  insert="$(ag --nobreak --noheading . | fzf -m -d':' --preview 'ln={2}; bat {1} -H $ln -r $[$[$ln - 3] < 0 ? 0 : $[$ln - 3]]:' | cut -d':' -f1 | sed 's/\(.*\)/\"\1\"/g' | paste -sd ' ')"
  LBUFFER="$(echo $LBUFFER | sed 's/ *$//') $insert"
  LBUFFER=$(echo $LBUFFER | sed 's/^ *//')
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   my-fzf-ag-widget
bindkey '^f' my-fzf-ag-widget

# Ctrl-i to write local folders to the zle
function my-fzf-folder-widget() {
  # clear redundant space
  # allow multiple selection
  LBUFFER="$(echo $LBUFFER | sed 's/ *$//') \"$(fd . -L -H --type d | fzf -m )\""
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

# 'navi' backwards
# Utilities to quickly insert snippets into current line
# Snippets use the same format as navi(denisidoro/navi)'s cheat files
function ivan() {
  snip=$(cat ~/.dotfiles/zsh/navi/* | egrep -v '^(%.*)?$' \
    | sed '$!N;s/\n/ # /' | sed 's/^#//' \
    | fzf -d'#' --with-nth=1 --preview 'echo {2}' --nth=2 \
    | cut -d'#' -f2 | sed 's/^ *//')
  LBUFFER="$LBUFFER$snip"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   ivan
bindkey '^g' ivan
