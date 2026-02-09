#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# === Right side items (order: rightmost first) ===
# Layout from right edge: Calendar | [Battery Volume WiFi]

# --- Clock (rightmost) ---
sketchybar --add item calendar right \
           --set calendar \
                 update_freq=30 \
                 icon="􀐬" \
                 icon.font="SF Pro:Semibold:14.0" \
                 icon.color=$ICON_COLOR \
                 icon.padding_left=4 \
                 icon.padding_right=4 \
                 label.color=$LABEL_COLOR \
                 label.font="SF Pro:Semibold:13.0" \
                 background.drawing=off \
                 script="$PLUGIN_DIR/calendar.sh" \
                 click_script="open -a Calendar"

# --- Status icons (Battery | Volume | WiFi) in one bracket ---
sketchybar --add item battery right \
           --set battery \
                 update_freq=120 \
                 icon.font="SF Pro:Semibold:14.0" \
                 icon.padding_left=6 \
                 icon.padding_right=6 \
                 label.drawing=off \
                 background.drawing=off \
                 script="$PLUGIN_DIR/battery.sh" \
           --subscribe battery system_woke power_source_change

sketchybar --add item volume right \
           --set volume \
                 icon.font="SF Pro:Semibold:14.0" \
                 icon.padding_left=6 \
                 icon.padding_right=6 \
                 label.drawing=off \
                 background.drawing=off \
                 script="$PLUGIN_DIR/volume.sh" \
           --subscribe volume volume_change

sketchybar --add item wifi_icon right \
           --set wifi_icon \
                 update_freq=10 \
                 icon="􀙇" \
                 icon.font="SF Pro:Semibold:14.0" \
                 icon.color=$ICON_COLOR \
                 icon.padding_left=6 \
                 icon.padding_right=6 \
                 label.drawing=off \
                 background.drawing=off \
                 script="$PLUGIN_DIR/wifi.sh" \
           --subscribe wifi_icon wifi_change system_woke

sketchybar --add bracket status_bracket battery volume wifi_icon \
           --set status_bracket \
                 background.drawing=off
