#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Start Development Mode
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "Project name" }
# @raycast.packageName Workflow

# Documentation:
# @raycast.description Open project, terminal, and development tools
# @raycast.author ctxzz
# @raycast.authorURL https://raycast.com/ctxzz

directory=$1
foundDirectory=''

if [ -z "$directory" ]; then
  echo "❌ Empty directory is not allowed"
  exit 1
fi

# プロジェクトディレクトリを検索
echo "Searching for project:  $directory..."
set +e

# よくある場所を検索
searchPaths=(
  "$HOME/ws/hama-med"
  "$HOME/ghq/github.com/ctxzz"
  "$HOME/ghq/github.com"
)

for basePath in "${searchPaths[@]}"; do
  if [ -d "$basePath" ]; then
    directories=$(find "$basePath" -iname "*$directory*" -type d -maxdepth 3 2>/dev/null)
    for dir in $directories; do
      foundDirectory=$dir
      break 2
    done
  fi
done

if [ -z "$foundDirectory" ]; then
  echo "❌ No project found with name: $directory"
  exit 1
fi

echo "✓ Found project: $foundDirectory"

# VS Codeを左半分に配置
open -a "Visual Studio Code" "$foundDirectory"
sleep 1
osascript <<EOF
tell application "Visual Studio Code"
    activate
end tell
tell application "System Events"
    keystroke "left" using {control down, option down}
end tell
EOF

# Warpを右半分に配置
sleep 0.5
open -a "Warp" "$foundDirectory"
sleep 1
osascript <<EOF
tell application "Warp"
    activate
end tell
tell application "System Events"
    keystroke "right" using {control down, option down}
end tell
EOF

echo "✓ Development mode activated"
echo "  - VS Code (left half)"
echo "  - Warp (right half)"
