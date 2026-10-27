#!/bin/bash
source "$CONFIG_DIR/colors.sh"

batt=$(pmset -g batt)
pct=$(grep -Eo '[0-9]+%' <<<"$batt" | tr -d %)
[ -z "$pct" ] && exit 0

color=$WHITE
case $pct in
  9[0-9] | 100) icon=􀛨 ;;
  [6-8][0-9]) icon=􀺸 ;;
  [3-5][0-9]) icon=􀺶 ;;
  [1-2][0-9]) icon=􀛩 color=$ORANGE ;;
  *) icon=􀛪 color=$RED ;;
esac
grep -q 'AC Power' <<<"$batt" && icon=􀢋

sketchybar --set "$NAME" icon="$icon" icon.color="$color"
