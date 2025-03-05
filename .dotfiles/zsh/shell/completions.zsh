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
