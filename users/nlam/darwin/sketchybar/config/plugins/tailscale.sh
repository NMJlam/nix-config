#!/bin/bash
# Green when Tailscale is connected, red otherwise (stopped, logged out, app closed).
source "$CONFIG_DIR/colors.sh"
state=$(tailscale status --json 2>/dev/null | jq -r .BackendState)
[ "$state" = Running ] && color=$GREEN || color=$RED
sketchybar --set "$NAME" icon.color="$color"
