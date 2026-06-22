#!/bin/bash
# Desktop/terminal notification when agent finishes a turn.
# Event: Stop

MESSAGE="${CLAUDE_NOTIFICATION_MESSAGE:-Claude finished}"

# Terminal bell
printf "\a"

# macOS
if command -v osascript &>/dev/null; then
  osascript -e "display notification \"$MESSAGE\" with title \"Claude Code\"" 2>/dev/null
  exit 0
fi

# Linux
if command -v notify-send &>/dev/null; then
  notify-send "Claude Code" "$MESSAGE" --icon=terminal 2>/dev/null
fi

exit 0
