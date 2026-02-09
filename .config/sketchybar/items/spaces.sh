#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all); do
  sketchybar --add item space.$sid left \
             --subscribe space.$sid aerospace_workspace_change \
             --set space.$sid \
                   icon="$sid" \
                   icon.padding_left=10 \
                   icon.padding_right=10 \
                   icon.color=$INACTIVE_COLOR \
                   icon.highlight_color=$WHITE \
                   label.drawing=off \
                   background.color=$TRANSPARENT \
                   background.corner_radius=8 \
                   background.height=28 \
                   background.drawing=on \
                   padding_left=2 \
                   padding_right=2 \
                   click_script="aerospace workspace $sid" \
                   script="$PLUGIN_DIR/aerospace.sh $sid"
done

sketchybar --add bracket spaces '/space\..*/' \
           --set spaces \
                 background.color=0xb0363a4f \
                 background.corner_radius=12 \
                 background.height=28 \
                 background.border_width=0

sketchybar --add item space_separator left \
           --set space_separator \
                 icon="􀆊" \
                 icon.font="SF Pro:Semibold:12.0" \
                 icon.color=$LABEL_COLOR \
                 icon.padding_left=4 \
                 icon.padding_right=4 \
                 label.drawing=off \
                 background.drawing=off
