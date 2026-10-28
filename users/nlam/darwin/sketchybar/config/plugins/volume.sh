#!/bin/bash
# volume = slider that slides out on change; volume.icon = speaker, click toggles the slider.
get_volume() { osascript -e 'output volume of (get volume settings)'; }

case "$NAME:$SENDER" in
  volume:volume_change)
    sketchybar --set volume slider.percentage="$INFO" \
      --animate tanh 30 --set volume slider.width=100
    sleep 2
    # Only hide if the volume didn't change again meanwhile.
    [ "$(sketchybar --query volume | jq -r .slider.percentage)" = "$INFO" ] &&
      sketchybar --animate tanh 30 --set volume slider.width=0
    ;;
  volume:mouse.clicked) osascript -e "set volume output volume $PERCENTAGE" ;;
  volume:*) sketchybar --set volume slider.percentage="$(get_volume)" ;;
  volume.icon:mouse.clicked)
    [ "$(sketchybar --query volume | jq -r .slider.width)" = 0 ] && w=100 || w=0
    sketchybar --animate tanh 30 --set volume slider.width=$w
    ;;
  volume.icon:*)
    v=${INFO:-$(get_volume)}
    case $v in
      0) icon=􀊣 ;;
      [0-9] | [1-2][0-9] | 3[0-2]) icon=􀊥 ;;
      3[3-9] | [4-5][0-9] | 6[0-5]) icon=􀊧 ;;
      *) icon=􀊩 ;;
    esac
    sketchybar --set volume.icon icon="$icon"
    ;;
esac
