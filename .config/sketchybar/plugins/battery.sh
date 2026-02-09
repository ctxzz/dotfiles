#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [[ $CHARGING != "" ]]; then
  ICON="􀢋"
  COLOR=$GREEN
elif [[ $PERCENTAGE -gt 75 ]]; then
  ICON="􀛨"
  COLOR=$WHITE
elif [[ $PERCENTAGE -gt 50 ]]; then
  ICON="􀺸"
  COLOR=$WHITE
elif [[ $PERCENTAGE -gt 25 ]]; then
  ICON="􀺶"
  COLOR=$YELLOW
elif [[ $PERCENTAGE -gt 10 ]]; then
  ICON="􀛩"
  COLOR=$ORANGE
else
  ICON="􀛪"
  COLOR=$RED
fi

sketchybar --set $NAME icon="$ICON" icon.color=$COLOR
