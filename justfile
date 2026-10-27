# Set the wallpaper on every screen from wallpapers/. No name: list them.
wallpaper name="":
    #!/usr/bin/env bash
    set -euo pipefail
    cd wallpapers
    if [ -z "{{name}}" ]; then ls; exit; fi
    f=$(basename "{{name}}") # accept "x.jpg" or tab-completed "wallpapers/x.jpg"
    [ -f "$f" ] || { echo "no such wallpaper: $f" >&2; ls >&2; exit 1; }
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$PWD/$f\""
