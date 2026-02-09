#!/bin/bash

source "$CONFIG_DIR/colors.sh"

WIFI_INTERFACE=$(networksetup -listallhardwareports 2>/dev/null | awk '/Wi-Fi/{getline; print $2}')

if [ -z "$WIFI_INTERFACE" ]; then
  WIFI_INTERFACE="en0"
fi

IP=$(ipconfig getifaddr "$WIFI_INTERFACE" 2>/dev/null)
if [ -z "$IP" ]; then
  sketchybar --set $NAME icon="􀙈" icon.color=$RED
  exit 0
fi

sketchybar --set $NAME icon="􀙇" icon.color=$ICON_COLOR
