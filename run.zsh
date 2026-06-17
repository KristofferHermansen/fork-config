#!/bin/zsh

set -euo pipefail

# Auto-populate from Fork's environment (PWD = repo path, set by Fork)
export REPO_PATH="${REPO_PATH:-$PWD}"
export REPO_NAME="${REPO_NAME:-$(basename "$REPO_PATH")}"

SCRIPT_NAME="${1:-}"

if [[ -z "$SCRIPT_NAME" ]]; then
  echo "Usage: run.zsh <script_name>"
  echo ""
  echo "Available scripts:"
  for f in "$(dirname "$0")/custom_scripts/"*.zsh; do
    echo "  $(basename "$f" .zsh)"
  done
  exit 1
fi

SCRIPTS_DIR="$(dirname "$0")/custom_scripts"
SCRIPT_PATH="$SCRIPTS_DIR/${SCRIPT_NAME}.zsh"

if [[ ! -f "$SCRIPT_PATH" ]]; then
  echo "Error: script not found: $SCRIPT_PATH"
  echo ""
  echo "Available scripts:"
  for f in "$SCRIPTS_DIR/"*.zsh; do
    echo "  $(basename "$f" .zsh)"
  done
  exit 1
fi

exec zsh "$SCRIPT_PATH"
