#!/bin/bash
# Plays escalating Dota 2 sounds based on how many times context has been compacted
# 1st compact = levelup, 2nd = rampage, 3rd+ = GODLIKE

input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // "default"')
counter_file="/tmp/claude-compact-count-${session_id}"

# Read and increment counter
count=0
if [ -f "$counter_file" ]; then
  count=$(cat "$counter_file")
fi
count=$((count + 1))
echo "$count" > "$counter_file"

SOUNDS_DIR="$HOME/.claude/sounds"

if [[ "$(defaults read com.henrikruscon.Klack enableListener 2>/dev/null)" == "1" ]]; then
  if [ "$count" -ge 3 ]; then
    afplay "$SOUNDS_DIR/godlike.mp3" &
  elif [ "$count" -eq 2 ]; then
    afplay "$SOUNDS_DIR/rampage.mp3" &
  else
    afplay "$SOUNDS_DIR/levelup.mp3" &
  fi
fi
