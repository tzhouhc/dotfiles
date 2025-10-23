#!/bin/zsh

# Script to prompt for system updates every two weeks
STATE_DIR="$HOME/.local/state"
TIMESTAMP_FILE="$STATE_DIR/health_check_timestamp"
LOCKFILE="$STATE_DIR/health.lock"

if ! ln "$0" "$LOCKFILE" 2>/dev/null; then
  # Lock exists; another process is running the update
  return 0
fi

if [[ ! -d "$STATE_DIR" ]]; then
  mkdir -p "$STATE_DIR"
fi

if [[ -z "$ZELLIJ" ]]; then
  return 0
fi

function check_timestamp() {
  if [[ ! -f "$TIMESTAMP_FILE" ]]; then
    touch "$TIMESTAMP_FILE"
    return 0
  fi
  current_time=$(date +%s)
  file_time=$(stat -c %Y "$TIMESTAMP_FILE")
  touch "$TIMESTAMP_FILE"
  time_diff=$((current_time - file_time))
  # two_weeks=$((14 * 24 * 60 * 60))
  two_weeks=$((10))

  # Return 0 (true) if two weeks have passed, 1 (false) otherwise
  [[ $time_diff -ge $two_weeks ]]
}

function update() {
    touch "$TIMESTAMP_FILE"

    dfg pull
}

if check_timestamp; then
  update
fi

/bin/rm -f "$LOCKFILE"


