#!/bin/bash
# Blue when any Bluetooth device is connected, dim otherwise (no event for this, so it polls).
source "$CONFIG_DIR/colors.sh"
system_profiler SPBluetoothDataType -json |
  jq -e '.SPBluetoothDataType[0].device_connected | length > 0' >/dev/null &&
  color=$BLUE || color=$BACKGROUND_2
sketchybar --set "$NAME" icon.color="$color"
