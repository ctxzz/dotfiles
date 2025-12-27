#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Start Meeting Mode
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "Slides directory name" }
# @raycast.packageName Workflow

# Documentation:
# @raycast.description Open Obsidian and slides directory for meetings
# @raycast.author ctxzz
# @raycast.authorURL https://raycast.com/ctxzz

directory=$1
foundDirectory=''

if [ -z "$directory" ]; then
  echo "❌ Empty directory is not allowed"
  exit 1
fi

# スライドディレクトリを検索
echo "Searching for slides directory:  $directory..."
set +e

# よくある場所を検索
searchPaths=(
  "$HOME/ws/slide/00hamamed/regular"
  "$HOME/ws/slide"
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
  echo "❌ No directory found with name: $directory"
  exit 1
fi

echo "✓ Found slides:  $foundDirectory"

# Obsidianを左半分に配置
open -a "Obsidian"
sleep 1
osascript <<EOF
tell application "Obsidian"
    activate
end tell
tell application "System Events"
    keystroke "left" using {control down, option down}
end tell
EOF

# VS Codeでスライドディレクトリを右半分に配置
sleep 0.5
open -a "Visual Studio Code" "$foundDirectory"
sleep 1
osascript <<EOF
tell application "Visual Studio Code"
    activate
end tell
tell application "System Events"
    keystroke "right" using {control down, option down}
end tell
EOF

echo "✓ Meeting mode activated"
echo "  - Obsidian (left half)"
echo "  - VS Code with slides (right half)"
