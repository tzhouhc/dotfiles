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

if check_timestamp; then
  touch "$TIMESTAMP_FILE"

  echo "It's been two weeks since the last update check."
  echo -n "Would you like to run updates now? (y/n): "
  read answer

  if [[ "$answer" =~ ^[Yy]$ ]]; then
    echo "Running system updates..."

    zinit update
    omp upgrade
    brew upgrade
    ulimit -n 10240; brew update
  else
    echo "Updates skipped. Will check again in two weeks."
  fi
fi
