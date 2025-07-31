#!/bin/zsh

# Script to prompt for system updates every two weeks
STATE_DIR="$HOME/.local/state"
TIMESTAMP_FILE="$STATE_DIR/update_check_timestamp"

if [[ ! -d "$STATE_DIR" ]]; then
  mkdir -p "$STATE_DIR"
fi

function check_timestamp() {
  if [[ ! -f "$TIMESTAMP_FILE" ]]; then
    touch "$TIMESTAMP_FILE"
    return 0
  fi
  current_time=$(date +%s)
  file_time=$(stat -c %Y "$TIMESTAMP_FILE")
  time_diff=$((current_time - file_time))
  two_weeks=$((14 * 24 * 60 * 60))

  # Return 0 (true) if two weeks have passed, 1 (false) otherwise
  [[ $time_diff -ge $two_weeks ]]
}

function update() {
    touch "$TIMESTAMP_FILE"

    echo "It's been two weeks since the last update check."
    echo -n "Would you like to run updates now? (y/n): "
    read answer

    if [[ "$answer" =~ ^[Yy]$ ]]; then
      echo "Running system updates..."

      # fzf
      pushd "$HOME/.fzf"
      ./install --bin
      popd

      # zsh stuff
      zinit update
      omp upgrade

      # homebrew
      brew upgrade
      ulimit -n 10240; brew update

      # bat cache
      if type bat &>/dev/null; then
        bat cache --build
      fi

      # macos
      # input method
      if [[ -d "$HOME/Library/Rime/" ]]; then
        pushd "$HOME/Library/Rime/";
        git pull
        popd
      fi
    else
      echo "Updates skipped. Will check again in two weeks."
    fi
}

if check_timestamp; then
  update
fi
