#!/usr/bin/env bash
# Run by AeroSpace at startup: Ghostty on workspace 1, Arc on workspace B.
# Windows are found by id and moved explicitly (not relying on focus).

place() {
  local app="$1" ws="$2" ids id

  open -a "$app"

  # Wait (up to ~10s) for at least one window of this app to exist.
  for _ in $(seq 1 20); do
    ids=$(aerospace list-windows --all --format '%{window-id}|%{app-name}' \
      | awk -F'|' -v a="$app" '$2 == a { print $1 }')
    [ -n "$ids" ] && break
    sleep 0.5
  done

  for id in $ids; do
    aerospace move-node-to-workspace --window-id "$id" "$ws"
  done
}

place "Ghostty" 1
place "Arc"     B

aerospace workspace 1
