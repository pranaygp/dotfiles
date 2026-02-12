#!/bin/bash
# Sets the Ghostty tab/window title by finding the real TTY device
# Usage: set-title.sh "title string"
TITLE="$1"
pid=$$
while [ "$pid" != "1" ] && [ -n "$pid" ]; do
  tty=$(ps -o tty= -p "$pid" 2>/dev/null | xargs)
  if [ "$tty" != "??" ] && [ -n "$tty" ]; then
    printf '\033]0;%s\007' "$TITLE" > "/dev/$tty" 2>/dev/null
    exit 0
  fi
  pid=$(ps -o ppid= -p "$pid" 2>/dev/null | xargs)
done
