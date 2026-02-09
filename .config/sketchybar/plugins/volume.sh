#!/bin/bash

source "$CONFIG_DIR/colors.sh"

if [ -n "$INFO" ]; then
  VOLUME="$INFO"
else
  VOLUME=$(osascript -e "output volume of (get volume settings)")
fi

MUTED=$(osascript -e "output muted of (get volume settings)")

if [[ "$MUTED" == "true" ]] || [[ "$VOLUME" -eq 0 ]]; then
  ICON="􀊠"
  COLOR=$GREY
elif [[ "$VOLUME" -gt 66 ]]; then
  ICON="􀊨"
  COLOR=$GREEN
elif [[ "$VOLUME" -gt 33 ]]; then
  ICON="􀊦"
  COLOR=$BLUE
elif [[ "$VOLUME" -gt 0 ]]; then
  ICON="􀊤"
  COLOR=$YELLOW
fi

sketchybar --set $NAME icon="$ICON" icon.color="$COLOR"
