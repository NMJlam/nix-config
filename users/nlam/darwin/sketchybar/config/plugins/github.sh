#!/bin/bash
# Unread GitHub notifications (needs `gh auth login`).
count=$(gh api notifications --jq length 2>/dev/null) || {
  sketchybar --set "$NAME" label=?
  exit 0
}
[ "$count" = 0 ] && icon=􀋚 || icon=􀝗
sketchybar --set "$NAME" icon="$icon" label="$count"
