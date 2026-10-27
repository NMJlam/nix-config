#!/bin/bash
# Workspace items: number + app icon strip, always visible. Empty workspaces are
# hidden; the focused one is marked by colour only (red number, lighter strip),
# so switching never changes widths and nothing on the bar jumps.
source "$CONFIG_DIR/colors.sh"

focus() { # $1 = workspace, $2 = on|off
  local bg=$BACKGROUND_2
  [ "$2" = on ] && bg=$SURFACE
  args+=(--set "space.$1" icon.highlight="$2" label.background.color="$bg")
}

if [ "$SENDER" = aerospace_workspace_change ]; then
  # Fast path: recolour the two workspaces involved, no aerospace queries.
  args=(--set "space.$FOCUSED_WORKSPACE" drawing=on)
  focus "$FOCUSED_WORKSPACE" on
  if [ -n "$PREV_WORKSPACE" ] && [ "$PREV_WORKSPACE" != "$FOCUSED_WORKSPACE" ]; then
    focus "$PREV_WORKSPACE" off
    # Leaving an empty workspace: hide it.
    [ "$(aerospace list-windows --workspace "$PREV_WORKSPACE" --count)" = 0 ] &&
      args+=(--set "space.$PREV_WORKSPACE" drawing=off)
  fi
  sketchybar --animate tanh 10 "${args[@]}"
  exit 0
fi

# Anything else (startup, app/window changes): rebuild icon strips and visibility.
. icon_map.sh # from sketchybar-app-font, on the agent's PATH; defines __icon_map

focused=$(aerospace list-workspaces --focused)
windows=$(aerospace list-windows --all --format '%{workspace}|%{app-name}')

args=()
for sid in $(aerospace list-workspaces --all); do
  icons=""
  while IFS='|' read -r ws app; do
    [ "$ws" = "$sid" ] || continue
    __icon_map "$app"
    icons+=" $icon_result"
  done <<<"$windows"

  if [ -z "$icons" ] && [ "$sid" != "$focused" ]; then
    args+=(--set "space.$sid" drawing=off)
    continue
  fi
  label_drawing=on
  [ -z "$icons" ] && label_drawing=off
  args+=(--set "space.$sid" drawing=on label="$icons" label.drawing=$label_drawing label.width=dynamic)
  if [ "$sid" = "$focused" ]; then focus "$sid" on; else focus "$sid" off; fi
done
sketchybar "${args[@]}"
