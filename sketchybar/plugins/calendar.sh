#!/bin/bash

# Shows the next timed work meeting today, e.g. "Standup in 12m" or "Standup 14:30".
# Needs Calendar access: System Settings > Privacy & Security > Calendars.
# List calendar names with: icalBuddy calendars

WORK_CALENDAR="peter@tails.com"

EVENT="$(icalBuddy -ic "$WORK_CALENDAR" -n -nc -nrd -ea -eed -b '' -li 1 -iep title,datetime \
  -po title,datetime -ps '| @ |' -tf '%H:%M' -df '' eventsToday 2>/dev/null | head -1)"

START="$(printf '%s' "$EVENT" | grep -Eo '[0-9]{2}:[0-9]{2}' | head -1)"
TITLE="${EVENT%% @ *}"

if [ -z "$START" ] || [ -z "$TITLE" ]; then
  sketchybar --set "$NAME" drawing=off --set "${NAME}_sep" drawing=off
  exit 0
fi

[ ${#TITLE} -gt 25 ] && TITLE="${TITLE:0:24}…"

# Round up, so 10m30s left shows "in 11m" and the last minute shows "in 1m"
SECONDS_LEFT=$(( $(date -j -f '%H:%M:%S' "$START:00" +%s) - $(date +%s) ))
MINUTES=$(( (SECONDS_LEFT + 59) / 60 ))
COLOR=0xffffffff

if [ "$SECONDS_LEFT" -le 0 ]; then
  WHEN="now"
elif [ "$MINUTES" -le 60 ]; then
  WHEN="in ${MINUTES}m"
  [ "$MINUTES" -le 1 ] && COLOR=0xfff38ba8
else
  WHEN="$START"
fi

sketchybar --set "$NAME" drawing=on label="$TITLE $WHEN" icon.color=$COLOR label.color=$COLOR \
           --set "${NAME}_sep" drawing=on
