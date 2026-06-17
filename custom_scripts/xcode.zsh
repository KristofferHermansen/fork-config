#!/bin/zsh
set -euo pipefail

echo "==> Repo: $REPO_NAME"
echo "==> Repo path: $REPO_PATH"

SETUP_SCRIPT="$HOME/Git/fork-config/custom_scripts/repo_setup.zsh"

echo "==> Running repo setup..."
zsh "$SETUP_SCRIPT"

echo "==> Opening Xcode..."
open -a Xcode "$REPO_PATH"
echo "==> Done."
