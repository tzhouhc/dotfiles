#!/usr/bin/env zsh

CREDS_DIR="$HOME/.credentials"
mkdir -p "$CREDS_DIR"
cd "$CREDS_DIR"

if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
  ssh-keygen
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "Logging into Github."
  # always use default github.com;
  # always use ssh key for auth;
  # always use web interface, which will fail, then perform the login manually
  # from the host.
  gh auth login -p ssh -h github.com -w
fi

spec_file="./spec.csv"

if [[ ! -f "$spec_file" ]]; then
  echo "Missing spec.csv at $spec_file"
  exit 1
fi

echo "Parsed spec.csv for credential fetching."

while IFS=',' read -r display_name secret_id cred_filename; do
  skip=0
  if [[ -f "$cred_filename" ]]; then
    echo "$display_name exists!"
    overwrite=$(echo "yes,no" | gum choose --input-delimiter=',' --header="Overwrite existing $display_name?")
    if [[ "$overwrite" =~ "no" ]]; then
      skip=1
    fi
  else
    echo "$display_name does not exist yet."
  fi

  if [[ $skip -eq 0 ]]; then
    echo "Fetching $display_name."
    clear_val="$(fetch-secret "$secret_id")"

    if [[ -n "$clear_val" ]]; then
      echo "$clear_val" | age -R "$HOME/.ssh/id_ed25519.pub" -o "$cred_filename"
    fi
    echo "Acquired $display_name"
  fi
done < "$spec_file"
