#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

# Pins each workspace item to the bar of the monitor it lives on, then highlights
# the visible workspace on every monitor (green when focused, grey otherwise).
# Also names the app on each monitor: the focused app on the focused monitor, and
# whatever is open on the visible workspace of the others.
# AeroSpace and SketchyBar number monitors differently, so map them via the
# NSScreen index, which matches SketchyBar's display arrangement-id.

FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused </dev/null)}"
FOCUSED_APP="$(aerospace list-windows --focused --format '%{app-name}' </dev/null 2>/dev/null)"
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

    if [ "$visible" = "$FOCUSED" ]; then
        app="$FOCUSED_APP"
    else
        app="$(aerospace list-windows --workspace "$visible" --format '%{app-name}' </dev/null \
            | awk '!seen[$0]++' | paste -sd ',' - | sed 's/,/, /g')"
    fi

    # Monitors plugged in after startup need their app item creating
    if ! sketchybar --query "front_app.$display" >/dev/null 2>&1; then
        sketchybar --add item "front_app.$display" left --set "front_app.$display" icon.drawing=off
    fi

    if [ -n "$app" ]; then
        args+=(--set "front_app.$display" display="$display" drawing=on label="$app")
    else
        args+=(--set "front_app.$display" drawing=off)
    fi
done < <(aerospace list-monitors --format '%{monitor-id}|%{monitor-appkit-nsscreen-screens-id}')

sketchybar "${args[@]}"
