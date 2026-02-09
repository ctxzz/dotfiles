#!/bin/bash

HOUR=$(date '+%H')

if [ "$HOUR" -ge 5 ] && [ "$HOUR" -lt 8 ]; then
  ICON="􀆲"   # sunrise.fill
elif [ "$HOUR" -ge 8 ] && [ "$HOUR" -lt 16 ]; then
  ICON="􀆮"   # sun.max.fill
elif [ "$HOUR" -ge 16 ] && [ "$HOUR" -lt 19 ]; then
  ICON="􀆴"   # sunset.fill
else
  ICON="􀇁"   # moon.stars.fill
fi

sketchybar --set $NAME icon="$ICON" label="$(date '+%H:%M')"
