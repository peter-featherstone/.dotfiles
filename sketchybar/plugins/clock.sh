#!/bin/sh

# Shows e.g. "8th Oct 6:54"

DAY=$(date '+%-d')

case "$DAY" in
  1|21|31) SUFFIX="st" ;;
  2|22)    SUFFIX="nd" ;;
  3|23)    SUFFIX="rd" ;;
  *)       SUFFIX="th" ;;
esac

TIME=$(date '+%-I:%M')

sketchybar --set "$NAME" label="${DAY}${SUFFIX} $(date '+%b') ${TIME}"
