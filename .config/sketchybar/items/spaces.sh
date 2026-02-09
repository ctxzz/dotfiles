#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

workspace_icon() {
  case "$1" in
    I) echo "􀂒" ;;  # Inbox (square)
    O) echo "􀀀" ;;  # Office (circle)
    P) echo "􀛣" ;;  # Private (triangle)
    1) echo "1" ;;
    2) echo "2" ;;
    3) echo "3" ;;
    R) echo "􀅷" ;;  # Read (at)
    W) echo "􀆃" ;;  # Write (number)
    E) echo "􀸓" ;;  # Execute (asterisk)
    *) echo "$1" ;;
  esac
}

sketchybar --add event aerospace_workspace_change

WORKSPACE_ORDER="1 2 3 I O P W E R"

for sid in $WORKSPACE_ORDER; do
  ICON=$(workspace_icon "$sid")
  sketchybar --add item space.$sid left \
             --subscribe space.$sid aerospace_workspace_change \
             --set space.$sid \
                   icon="$ICON" \
                   icon.padding_left=10 \
                   icon.padding_right=10 \
                   icon.color=$INACTIVE_COLOR \
                   icon.highlight_color=$WHITE \
                   icon.font="SF Pro:Semibold:14.0" \
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

sketchybar --set space.W icon.font="SF Pro:Semibold:12.0" \
           --set space.E icon.font="SF Pro:Semibold:12.0" \
           --set space.R icon.font="SF Pro:Semibold:12.0"

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
