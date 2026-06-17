#!/bin/zsh
set -euo pipefail

echo "==> Repo: $REPO_NAME"
echo "==> Repo path: $REPO_PATH"

CONFIG_DIR="$HOME/.warp/launch_configurations"
CONFIG_NAME="${REPO_NAME}-opencode"
CONFIG_FILE="$CONFIG_DIR/$CONFIG_NAME.yaml"
SETUP_SCRIPT="$HOME/Git/fork-config/custom_scripts/repo_setup.zsh"

echo "==> Repo path: $REPO_PATH"
echo "==> Writing Warp launch configuration..."

mkdir -p "$CONFIG_DIR"

cat > "$CONFIG_FILE" <<EOF
---
name: $CONFIG_NAME
windows:
  - tabs:
      - title: $REPO_NAME
        layout:
          split_direction: vertical
          panes:
            - cwd: $REPO_PATH
              commands:
                - exec: opencode
            - cwd: $REPO_PATH
              commands:
                - exec: zsh $SETUP_SCRIPT
                - exec: rm -f "$CONFIG_FILE"
EOF

echo "==> Launching Warp..."
open "warp://launch/$CONFIG_NAME"

echo "==> Opening Xcode..."
open -a Xcode "$REPO_PATH"
echo "==> Done."
