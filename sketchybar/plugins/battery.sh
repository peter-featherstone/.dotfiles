#!/bin/sh

# Battery percentage: green 60-100%, yellow 20-59%, red below 20%

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

if [ "$PERCENTAGE" -ge 60 ]; then
  COLOR=0xffa6e3a1
elif [ "$PERCENTAGE" -ge 20 ]; then
  COLOR=0xfff9e2af
else
  COLOR=0xfff38ba8
fi

sketchybar --set "$NAME" label="${PERCENTAGE}%" label.color=$COLOR
