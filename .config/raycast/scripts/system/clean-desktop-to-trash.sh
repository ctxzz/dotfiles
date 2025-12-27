#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Clean Desktop to Trash
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName System

# Documentation:
# @raycast.description Move all desktop files to trash
# @raycast.author ctxzz
# @raycast.authorURL https://raycast.com/ctxzz

count=$(find ~/Desktop -maxdepth 1 -type f | wc -l | tr -d ' ')

if [ "$count" -eq 0 ]; then
    echo "Desktop is already clean"
    exit 0
fi

find ~/Desktop -maxdepth 1 -type f -exec mv {} "$HOME/.Trash/" \;
echo "✓ Moved $count file(s) to trash"
