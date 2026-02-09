#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME \
    icon.color=$WHITE \
    icon.highlight=off
else
  sketchybar --set $NAME \
    icon.color=$INACTIVE_COLOR \
    icon.highlight=off
fi
