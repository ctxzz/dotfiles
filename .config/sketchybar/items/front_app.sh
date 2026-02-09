#!/bin/bash

source "$CONFIG_DIR/colors.sh"

sketchybar --add item front_app left \
           --set front_app \
                 icon.font="sketchybar-app-font:Regular:16.0" \
                 icon.color=$ICON_COLOR \
                 icon.padding_left=4 \
                 icon.padding_right=4 \
                 label.font="SF Pro:Semibold:14.0" \
                 label.color=$LABEL_COLOR \
                 background.drawing=off \
                 script="$PLUGIN_DIR/front_app.sh" \
           --subscribe front_app front_app_switched
