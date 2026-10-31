# Move the focused pane to side $1 (left|down|up|right), like aerospace `move`: next to the
# neighbor on that side, or at an edge, to that side of whichever pane it shares a split with.
d=$1 p=$HERDR_ACTIVE_PANE_ID h=$HERDR_BIN_PATH
nb() { "$h" pane neighbor --pane "$p" --direction "$1" | sed -n 's/.*"neighbor_pane_id":"\([^"]*\)".*/\1/p'; }
for x in "$d" left right up down; do
  n=$(nb "$x")
  [ -n "$n" ] && break
done
[ -n "$n" ] || exit 0
t=$("$h" pane get "$p" | sed -n 's/.*"tab_id":"\([^"]*\)".*/\1/p')
case $d in left | right) s=right ;; *) s=down ;; esac
{
  # Herdr won't move a pane within its own tab, so bounce it through a throwaway tab.
  "$h" pane move "$p" --new-tab --no-focus
  "$h" pane move "$p" --tab "$t" --target-pane "$n" --split "$s" --focus
  # Herdr only splits right/down, so left/up swap the pane over.
  case $d in left | up) "$h" pane swap --source-pane "$p" --target-pane "$n" ;; esac
} >/dev/null
