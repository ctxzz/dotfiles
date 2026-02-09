#!/bin/bash

source "$CONFIG_DIR/colors.sh"

sketchybar --bar height=37 \
                 blur_radius=30 \
                 position=top \
                 sticky=on \
                 padding_left=10 \
                 padding_right=10 \
                 color=$BAR_COLOR \
                 shadow=off \
                 y_offset=0 \
                 margin=0 \
                 corner_radius=0 \
                 border_width=0 \
                 notch_width=0
