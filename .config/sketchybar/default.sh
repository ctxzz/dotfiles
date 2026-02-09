#!/bin/bash

source "$CONFIG_DIR/colors.sh"

sketchybar --default icon.font="SF Pro:Semibold:15.0" \
                     icon.color=$ICON_COLOR \
                     icon.padding_left=4 \
                     icon.padding_right=4 \
                     label.font="SF Pro:Semibold:15.0" \
                     label.color=$LABEL_COLOR \
                     label.padding_left=4 \
                     label.padding_right=4 \
                     padding_left=3 \
                     padding_right=3 \
                     background.height=28 \
                     background.corner_radius=8 \
                     background.border_width=0 \
                     background.color=$BG1 \
                     popup.background.border_width=2 \
                     popup.background.corner_radius=9 \
                     popup.background.border_color=$POPUP_BORDER_COLOR \
                     popup.background.color=$POPUP_BACKGROUND_COLOR \
                     popup.blur_radius=20 \
                     popup.background.shadow.drawing=on
