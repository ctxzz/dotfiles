#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title AeroSpace: List Workspaces
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName AeroSpace

# Documentation:
# @raycast.description Show AeroSpace workspace list (focused marked with *).
# @raycast.author ctxzz
# @raycast.authorURL https://raycast.com/ctxzz

set -euo pipefail

if ! command -v aerospace >/dev/null 2>&1; then
  echo "Error: 'aerospace' command not found."
  exit 1
fi

# --- ANSI colors (Raycast fullOutput renders these nicely) ---
BOLD=$'\033[1m'
DIM=$'\033[2m'
RESET=$'\033[0m'

GREEN=$'\033[32m'
CYAN=$'\033[36m'
YELLOW=$'\033[33m'
GRAY=$'\033[90m'

FOCUSED_WS="$(aerospace list-workspaces --focused --format '%{workspace}' | tr -d '[:space:]')"
WORKSPACES="$(aerospace list-workspaces --all --format '%{workspace}')"

for WS in $WORKSPACES; do
  # Force a predictable format: "App Name | Window Title"
  WINDOWS="$(aerospace list-windows --workspace "$WS" --format '%{app-name} | %{window-title}' 2>/dev/null || true)"

  # Skip empty workspaces
  if [ -z "${WINDOWS//[[:space:]]/}" ]; then
    continue
  fi

  # Header with current workspace highlight
  if [ "$WS" = "$FOCUSED_WS" ]; then
    printf "%s%s▶ Workspace: %s (current)%s\n" "$BOLD" "$GREEN" "$WS" "$RESET"
  else
    printf "%sWorkspace: %s%s\n" "$BOLD" "$WS" "$RESET"
  fi
  echo "-----------------------------"

  # Pretty-print each window:
  # - App name in CYAN
  # - Title in DIM/GRAY (often long)
  echo "$WINDOWS" | while IFS='|' read -r APP TITLE; do
    APP="$(echo "$APP" | xargs)"
    TITLE="$(echo "$TITLE" | xargs)"

    # If title is empty (rare), still show the app
    if [ -z "$TITLE" ]; then
      printf "%s- %s%s%s\n" "$YELLOW" "$CYAN" "$APP" "$RESET"
    else
      printf "%s- %s%s%s %s%s%s\n" \
        "$YELLOW" "$CYAN" "$APP" "$RESET" "$GRAY" "$TITLE" "$RESET"
    fi
  done

  echo
done