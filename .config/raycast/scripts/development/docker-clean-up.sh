#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Docker Clean Up
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Development

# Documentation:
# @raycast.description Remove stopped containers, unused images and networks
# @raycast.author ctxzz
# @raycast.authorURL https://raycast.com/ctxzz

echo "Cleaning up Docker..."
docker container prune -f
docker image prune -f
docker network prune -f
docker volume prune -f
echo ""
echo "✓ Docker cleanup complete"
docker system df
