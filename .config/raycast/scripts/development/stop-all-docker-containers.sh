#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Stop All Docker Containers
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Development

# Documentation:
# @raycast.description Stop all running Docker containers
# @raycast.author ctxzz
# @raycast.authorURL https://raycast.com/ctxzz

containers=$(docker ps -q)
if [ -z "$containers" ]; then
    echo "No running containers"
else
    docker stop $containers
    echo "✓ All containers stopped"
fi
