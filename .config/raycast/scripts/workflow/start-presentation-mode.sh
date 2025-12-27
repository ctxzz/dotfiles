#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Start Presentation Mode
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Workflow

# Documentation:
# @raycast.description Setup for presentations
# @raycast.author ctxzz
# @raycast.authorURL https://raycast.com/ctxzz

# PowerPointを開く
open -a "Microsoft PowerPoint"

# Amphetamineを起動してスリープ防止
open -a "Amphetamine"

# 集中モードをオン（ショートカットアプリ経由）
shortcuts run "Enable Do Not Disturb"

echo "✓ Presentation mode activated"
echo "  - Amphetamine started"
echo "  - Do Not Disturb enabled"
