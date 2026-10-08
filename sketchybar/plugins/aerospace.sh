#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

# Pins each workspace item to the bar of the monitor it lives on, then highlights
# the visible workspace on every monitor (green when focused, grey otherwise).
# AeroSpace and SketchyBar number monitors differently, so map them via the
# NSScreen index, which matches SketchyBar's display arrangement-id.

FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"
args=()

while IFS='|' read -r monitor display; do
    visible=$(aerospace list-workspaces --monitor "$monitor" --visible </dev/null)

    for sid in $(aerospace list-workspaces --monitor "$monitor" </dev/null); do
        if [ "$sid" = "$FOCUSED" ]; then
            style=(background.drawing=on background.color=0xffa6e3a1 label.color=0xff000000)
        elif [ "$sid" = "$visible" ]; then
            style=(background.drawing=on background.color=0xff585b70 label.color=0xffffffff)
        else
            style=(background.drawing=off label.color=0xffffffff)
        fi

        args+=(--set "space.$sid" display="$display" "${style[@]}")
    done
done < <(aerospace list-monitors --format '%{monitor-id}|%{monitor-appkit-nsscreen-screens-id}')

sketchybar "${args[@]}"
