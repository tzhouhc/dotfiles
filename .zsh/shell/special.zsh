# customize zsh's behavior if a command is not found.
command_not_found_handler() {
# base case -- single argument, which is probably something local?
if [[ -d "$1" ]]; then
    echo "$1 is a directory."
  elif file --mime-type -b "$1" | grep -q '^text/'; then
    $EDITOR $@
  else
    echo "Command $1 not found."
    if ! confirm "Try something else?"; then
      return
    fi
    cmd=$(bin_list --query "$1")
    if [[ -n "$cmd" ]]; then
      shift
      exec "$cmd" $@
    fi
  fi
}
