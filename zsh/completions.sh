# customized vim completion
_fzf_complete_vim() {
  FZF_DEFAULT_OPTS="--preview 'bat --style=changes --color=always {} 2>/dev/null || ls -al {} 2>/dev/null || echo {}' $FZF_DEFAULT_OPTS"
  _fzf_complete '+m' "$@" < <(
    # all files under current dir
    fd . -t f
  )
  FZF_DEFAULT_OPTS="--height 40% --reverse"
}

_fzf_complete_v() {
  FZF_DEFAULT_OPTS="--preview 'bat --style=changes --color=always {} 2>/dev/null || ls -al {} 2>/dev/null || echo {}' $FZF_DEFAULT_OPTS"
  _fzf_complete '+m' "$@" < <(
    # all files under current dir
    fd . -t f
  )
  FZF_DEFAULT_OPTS="--height 40% --reverse"
}

_fzf_complete_g4d() {
  _fzf_complete '+m' "$@" < <(
    # all files under current dir
    ls --color=none /google/src/cloud/$USER/
  )
  FZF_DEFAULT_OPTS="--height 40% --reverse"
}

_fzf_complete_g4cd() {
  _fzf_complete "+m" "$@" < <(
    cat ~/.g3marks
  )
}

_fzf_complete_g4cd_post() {
  # remove the marker name bits
  cut -f2 -d$'\t'
}
