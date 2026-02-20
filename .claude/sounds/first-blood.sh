#!/bin/bash
# Plays first-blood sound only on the first prompt of a session

input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // "default"')
marker_file="/tmp/claude-first-blood-${session_id}"

if [ ! -f "$marker_file" ]; then
  touch "$marker_file"
  [[ "$(defaults read com.henrikruscon.Klack enableListener 2>/dev/null)" == "1" ]] && afplay "$HOME/.claude/sounds/first-blood.mp3" &
fi
