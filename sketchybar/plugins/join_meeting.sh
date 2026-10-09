#!/bin/sh

# Opens the next meeting's video link in Dia, in the Dia window on MEETING_WORKSPACE
# (or any Dia window if there isn't one there), switched to the MEETING_PROFILE space.
# Falls back to Calendar with no link.

# MEETING_PROFILE can be overridden in local.sh (gitignored, see local.example.sh)
[ -f "$CONFIG_DIR/local.sh" ] && . "$CONFIG_DIR/local.sh"
MEETING_WORKSPACE=2
MEETING_PROFILE="${MEETING_PROFILE:-Work}"

URL="$(cat "${TMPDIR:-/tmp}/sketchybar_meeting_url" 2>/dev/null)"

if [ -z "$URL" ]; then
  open -a Calendar
  exit 0
fi

WINDOW="$(aerospace list-windows --all --format '%{window-id}|%{workspace}|%{app-bundle-id}' \
  | awk -F'|' -v ws="$MEETING_WORKSPACE" '$3 == "company.thebrowser.dia" { print ($2 == ws ? 0 : 1) "|" $1 }' \
  | sort | head -1 | cut -d'|' -f2)"

[ -n "$WINDOW" ] && aerospace focus --window-id "$WINDOW"
# Links open in the window's focused space, so switch to the meeting one first
osascript -e 'on run argv' -e 'tell application "Dia" to focus profile (item 1 of argv) of window 1' \
  -e 'end run' "$MEETING_PROFILE" 2>/dev/null
open -a Dia "$URL"
