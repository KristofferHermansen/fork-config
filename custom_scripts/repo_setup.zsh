#!/bin/zsh
set -euo pipefail

SECRETS_DIR="$REPO_PATH/Secrets/Configs"
INJECT_SCRIPT="$REPO_PATH/scripts/inject-keys-from-1password.sh"

echo "==> Repo: $REPO_NAME"
echo "==> Repo path: $REPO_PATH"
echo "==> Checking secrets directory: $SECRETS_DIR"

if [[ -d "$SECRETS_DIR" ]]; then
  FOUND_FILES="$(find "$SECRETS_DIR" -mindepth 1 -type f 2>/dev/null || true)"

  if [[ -n "$FOUND_FILES" ]]; then
    echo "==> Found files in $SECRETS_DIR:"
    printf '%s\n' "$FOUND_FILES"
  else
    echo "==> Secrets directory exists but no files found."
    if [[ -f "$INJECT_SCRIPT" ]]; then
      echo "==> Running inject script: $INJECT_SCRIPT"
      zsh "$INJECT_SCRIPT"
    else
      echo "==> Inject script not found, skipping: $INJECT_SCRIPT"
    fi
  fi
else
  echo "==> Secrets directory does not exist."
  if [[ -f "$INJECT_SCRIPT" ]]; then
    echo "==> Running inject script: $INJECT_SCRIPT"
    zsh "$INJECT_SCRIPT"
  else
    echo "==> Inject script not found, skipping: $INJECT_SCRIPT"
  fi
fi

echo "==> Running xcodegen with Mint..."
cd "$REPO_PATH"
mint run xcodegen

echo "==> Done."
