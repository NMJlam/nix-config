#!/bin/bash
source "$CONFIG_DIR/colors.sh"

count=$(brew outdated --quiet | wc -l | tr -d ' ')
color=$RED
case $count in
  [3-5][0-9]) color=$ORANGE ;;
  [1-2][0-9]) color=$YELLOW ;;
  [1-9]) color=$WHITE ;;
  0) color=$GREEN count=􀆅 ;;
esac
sketchybar --set "$NAME" label="$count" icon.color="$color"
