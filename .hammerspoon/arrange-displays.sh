#!/usr/bin/env bash
#
# Place the external monitor above the built-in display (centered).
# macOS defaults new displays to side-by-side; this enforces stacked.
# Triggered by the Hammerspoon screen watcher (~/.hammerspoon/init.lua),
# or run manually.

set -euo pipefail

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

command -v displayplacer >/dev/null || { echo "displayplacer not installed (brew install displayplacer)" >&2; exit 1; }

# One line per screen:
# <id> <width> <height> <builtin|external> <main|-> <enabled> <origin> <hz> <color_depth> <scaling> <degree>
screens=$(displayplacer list | awk '
  function flush() { if (id != "") print id, w, h, type, main, enabled, origin, hz, depth, scaling, degree }
  /^Persistent screen id:/ { flush(); id=$4; type="?"; main="-"; enabled="true"; w=0; h=0; origin="?"; hz=60; depth=8; scaling="off"; degree=0 }
  /^Type:/        { type = ($0 ~ /built in/) ? "builtin" : "external" }
  /^Resolution:/  { split($2, r, "x"); w=r[1]; h=r[2] }
  /^Hertz:/       { hz=$2 }
  /^Color Depth:/ { depth=$3 }
  /^Scaling:/     { scaling=$2 }
  /^Origin:/      { origin=$2; if ($0 ~ /main display/) main="main" }
  /^Rotation:/    { degree=$2 }
  /^Enabled:/     { enabled=$2 }
  END { flush() }
')

builtin_info=$(awk '$4 == "builtin" && $6 == "true"' <<<"$screens" | head -1)
external_info=$(awk '$4 == "external" && $6 == "true"' <<<"$screens")

# Nothing to do with only one display (laptop-only or clamshell mode).
[[ -z "$builtin_info" || -z "$external_info" ]] && exit 0

# With multiple externals the desired arrangement is ambiguous; leave it alone.
if [[ $(wc -l <<<"$external_info") -gt 1 ]]; then
  echo "multiple external displays connected; leaving arrangement alone" >&2
  exit 0
fi

read -r b_id b_w b_h _ _ _ b_origin b_hz b_depth b_scaling b_degree <<<"$builtin_info"
read -r e_id e_w e_h _ e_main _ e_origin e_hz e_depth e_scaling e_degree <<<"$external_info"

IFS=', ' read -r b_x b_y <<<"${b_origin//[()]/}"
IFS=', ' read -r e_x e_y <<<"${e_origin//[()]/}"

# If the external already sits above the built-in display, leave the
# arrangement alone. This preserves any manual horizontal fine-tuning and
# keeps the Hammerspoon watcher from re-triggering itself.
if (( e_y + e_h <= b_y )); then
  exit 0
fi

if [[ "$e_main" == "main" ]]; then
  # The external is the main display: it must stay at (0,0), so put the
  # built-in screen below it instead.
  e_target="(0,0)"
  b_target="($(( (e_w - b_w) / 2 )),$e_h)"
else
  b_target="(0,0)"
  e_target="($(( (b_w - e_w) / 2 )),-$e_h)"
fi

displayplacer \
  "id:$b_id res:${b_w}x${b_h} hz:$b_hz color_depth:$b_depth enabled:true scaling:$b_scaling origin:$b_target degree:$b_degree" \
  "id:$e_id res:${e_w}x${e_h} hz:$e_hz color_depth:$e_depth enabled:true scaling:$e_scaling origin:$e_target degree:$e_degree"
