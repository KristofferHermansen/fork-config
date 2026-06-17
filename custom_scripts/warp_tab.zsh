#!/bin/zsh
set -euo pipefail

echo "==> Repo: $REPO_NAME"
echo "==> Opening new Warp tab at: $REPO_PATH"
open "warp://action/new_tab?path=$REPO_PATH"
echo "==> Done."
