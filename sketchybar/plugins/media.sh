#!/bin/sh

# Now playing from any app (Music, Spotify, browser tabs) via media-control,
# which still works on macOS 15.4+ where nowplaying-cli and media_change broke

INFO="$(media-control get 2>/dev/null)"
TITLE="$(printf '%s' "$INFO" | jq -r '.title // empty' 2>/dev/null)"
ARTIST="$(printf '%s' "$INFO" | jq -r '.artist // empty' 2>/dev/null)"
PLAYING="$(printf '%s' "$INFO" | jq -r '.playing // false' 2>/dev/null)"

if [ -z "$TITLE" ]; then
  sketchybar --set "$NAME" drawing=off --set "${NAME}_sep" drawing=off
  exit 0
fi

# Icon shows what clicking will do: pause while playing, play while paused
ICON=$([ "$PLAYING" = "true" ] && echo "󰏤" || echo "󰐊")
LABEL=$([ -n "$ARTIST" ] && echo "$ARTIST – $TITLE" || echo "$TITLE")

# Emoji push the label off the baseline the rest of the bar uses, so drop them
LABEL="$(printf '%s' "$LABEL" | perl -CSD -pe 's/[\x{1F000}-\x{1FAFF}\x{2600}-\x{27BF}\x{2B00}-\x{2BFF}\x{FE0F}\x{200D}]//g; s/ {2,}/ /g; s/^ | $//g')"

sketchybar --set "$NAME" drawing=on icon="$ICON" label="$LABEL" --set "${NAME}_sep" drawing=on
