_fzf_complete_cd() {
  _fzf_complete "+m --header-lines=1" "$@" < <(
    echo "Alias\tPath\n$(cat ~/.marks)" | column -t
  )
}

_fzf_complete_cd_post() {
  grep -o "[^ ]*$"
}

# ---------
# Google stuff
# ---------

# completion for piper
_fzf_complete_g4d() {
  _fzf_complete '+m' "$@" < <(
    # all files under current dir
    ls --color=none /google/src/cloud/$USER/
  )
  FZF_DEFAULT_OPTS="--height 40% --reverse"
}

_fzf_complete_g4do() {
  _fzf_complete "+m" "$@" < <(
    p4 p -l | grep depot --color=never | grep -v delete --color=never | sed 's/#[0-9]*//' | cut -d'/' -f5-11 | cut -d' ' -f1
  )
}

_fzf_complete_g4cd() {
  _fzf_complete "+m --header-lines=1" "$@" < <(
    echo "Alias\tG3path\n$(cat ~/.g3marks)" | column -t
  )
}

_fzf_complete_g4cd_post() {
  # remove the marker name bits
  grep -o "[^ ]*$"
}

_fzf_complete_bb() {
  _fzf_complete '+m' "$@" < <(
    # all files under current dir
    if [[ -a BUILD ]]; then
      cat BUILD | egrep '^\s+name \=' | sed "s/^[^\"]*\"//" | sed "s/\".*$//"
    fi
  )
}

_fzf_complete_bt() {
  _fzf_complete '+m' "$@" < <(
    # all files under current dir
    if [[ -a BUILD ]]; then
      cat BUILD | egrep '^\s+name \=' | sed "s/^[^\"]*\"//" | sed "s/\".*$//"
    fi
  )
}

_fzf_complete_br() {
  _fzf_complete '+m' "$@" < <(
    # all files under current dir
    if [[ -a BUILD ]]; then
      cat BUILD | egrep '^\s+name \=' | sed "s/^[^\"]*\"//" | sed "s/\".*$//"
    fi
  )
}

# Helper function that assigns function as an autocomplete provider for the
# given command.
assign_completer() {
    local cmd="$1"
    local func="$2"

    if [[ -z "$cmd" || -z "$func" ]]; then
        echo "Usage: assign_completer <command> <function_name>" >&2
        return 1
    fi

    # Check if the function exists
    if ! typeset -f "$func" > /dev/null; then
        echo "Error: Function '$func' does not exist" >&2
        return 1
    fi

    # Create a wrapper completion function
    local wrapper_name="_complete_${cmd}_wrapper"

    eval "
    $wrapper_name() {
        local -a completions
        local line

        # Call the user's function and capture output
        while IFS= read -r line; do
            completions+=(\"\$line\")
        done < <($func \"\$words[@]\")

        # Provide completions to zsh
        _describe 'completions' completions
    }
    "

    # Register the completion
    compdef "$wrapper_name" "$cmd"
}

# NOTE: Completion files in the completion dir should start with an underscore.
# Once the files are in, run `rm ~/.zcompdump*` to remove cached completions.

# Add to completion path
if type brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"
  fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)
fi

fpath=($HOME/.zsh/shell/completion $fpath)
if [ -f ~/.zsh_completions_dump ]; then
  source ~/.zsh_completions_dump
else
  autoload -Uz compinit
  compinit
  compdump ~/.zsh_completions_dump
fi

# Custom completers
ls_completer() {
  fd -t f .
}

ssh_host_completer() {
  cat ~/.ssh/config | grep '^Host' | cut -d' ' -f2
}

send_completer() {
  cat ~/.send.temp 2>/dev/null
}

# Simple custom completions
assign_completer pick ls_completer
assign_completer ssh ssh_host_completer
assign_completer scp ssh_host_completer
assign_completer drop send_completer
assign_completer paste send_completer
