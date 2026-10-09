#!/bin/bash

# Shows the next timed work meeting today, e.g. "Standup in 12m" or "Standup 14:30".
# Only events with a Meet/Zoom/Teams link count, which skips holidays and placeholders.
# Clicking it joins the meeting (see join_meeting.sh).
# Needs Calendar access: System Settings > Privacy & Security > Calendars.
# List calendar names with: icalBuddy calendars

# WORK_CALENDAR is set in local.sh (gitignored, see local.example.sh)
[ -f "$CONFIG_DIR/local.sh" ] && source "$CONFIG_DIR/local.sh"
CALENDARS=()
[ -n "$WORK_CALENDAR" ] && CALENDARS=(-ic "$WORK_CALENDAR")

LINK_PATTERN='https://(meet\.google\.com|[a-z0-9.-]*zoom\.us|teams\.microsoft\.com)/[^ <>"]+'

# One block per event, each starting with "###", in start time order
EVENTS="$(icalBuddy "${CALENDARS[@]}" -n -nc -nrd -ea -eed -b '###' \
  -iep title,datetime,url,location,notes -po title,datetime,url,location,notes \
  -ps '| @ |' -tf '%H:%M' -df '' "${CALENDAR_RANGE:-eventsToday}" 2>/dev/null)"

# Take the first event that has a meeting link
TITLE="" START="" LINK=""
while IFS= read -r -d $'\x1e' block; do
  link="$(printf '%s' "$block" | grep -Eo "$LINK_PATTERN" | head -1)"
  [ -z "$link" ] && continue

  first_line="$(printf '%s' "$block" | head -1)"
  TITLE="${first_line%% @ *}"
  START="$(printf '%s' "${first_line#* @ }" | grep -Eo '[0-9]{2}:[0-9]{2}' | head -1)"
  LINK="$link"
  break
done < <(printf '%s\n' "$EVENTS" | awk 'NR > 1 && /^###/ { printf "\036" } { sub(/^###/, ""); print } END { printf "\036" }')

# Saved for join_meeting.sh to open on click
printf '%s' "$LINK" > "${TMPDIR:-/tmp}/sketchybar_meeting_url"

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
