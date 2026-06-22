#!/bin/bash
# Reminds agent to close the session when stopping with in-progress work.
# Event: Stop

FEATURES=".harness/features.json"

[ -f "$FEATURES" ] || exit 0

IN_PROGRESS=$(jq '[.features[]? | select(.status == "in_progress")] | length' "$FEATURES" 2>/dev/null)

[ "$IN_PROGRESS" -gt 0 ] 2>/dev/null || exit 0

echo "SESSION GUARD: $IN_PROGRESS feature(s) still in_progress." >&2
echo "Run: ./harness session stop && ./harness clean" >&2

exit 0
