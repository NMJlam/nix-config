#!/bin/bash
# ponytail: ps %cpu is a decaying average, not Felix's mach helper; swap in a helper if it lags too much.
source "$CONFIG_DIR/colors.sh"

read -r load frac top < <(/bin/ps -Aco pid=,pcpu=,comm= -r | awk -v n="$(sysctl -n hw.ncpu)" '
  NR == 1 { t = $0; sub(/^ *[0-9]+ +[0-9.]+ +/, "", t); top = $1 " " $2 " " t }
  { s += $2 }
  END { printf "%d %.2f %s\n", s / n, s / n / 100, top }')

color=$WHITE
[ "$load" -gt 30 ] && color=$YELLOW
[ "$load" -gt 60 ] && color=$ORANGE
[ "$load" -gt 80 ] && color=$RED

sketchybar --push cpu.graph "$frac" \
  --set cpu.percent label="$load%" label.color="$color" \
  --set cpu.top label="$top"
