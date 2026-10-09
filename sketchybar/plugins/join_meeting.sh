#!/bin/sh

# Opens the next meeting's video link in Dia, in the Dia window on MEETING_WORKSPACE
# (or any Dia window if there isn't one there). Falls back to Calendar with no link.

MEETING_WORKSPACE=2

URL="$(cat "${TMPDIR:-/tmp}/sketchybar_meeting_url" 2>/dev/null)"

if [ -z "$URL" ]; then
  open -a Calendar
  exit 0
fi

WINDOW="$(aerospace list-windows --all --format '%{window-id}|%{workspace}|%{app-bundle-id}' \
  | awk -F'|' -v ws="$MEETING_WORKSPACE" '$3 == "company.thebrowser.dia" { print ($2 == ws ? 0 : 1) "|" $1 }' \
  | sort | head -1 | cut -d'|' -f2)"

[ -n "$WINDOW" ] && aerospace focus --window-id "$WINDOW"
open -a Dia "$URL"
