#!/usr/bin/env bash
# Warns (exit 0) or blocks (exit 1) when token context approaches threshold.
# Triggered on Stop event — Claude Code, Antigravity session_end.
# Reads threshold from .harness/context.json; default 150000 tokens.
# Does NOT hard-block by default — prints a strong warning and lets Claude decide.
# Set CONTEXT_GUARD_HARD=1 in env to make it a hard block.

CONTEXT_FILE=".harness/context.json"
TRACE_FILE=".harness/trace.log"

[ -f "$CONTEXT_FILE" ] || exit 0

THRESHOLD=$(python3 -c "
import json, sys
try:
    d = json.load(open('$CONTEXT_FILE'))
    print(d.get('context_warn_threshold', 150000))
except:
    print(150000)
" 2>/dev/null || echo 150000)

# Read total tokens from last harness trace entry if available
if [ -f "$TRACE_FILE" ]; then
    LAST_TOKENS=$(tail -1 "$TRACE_FILE" 2>/dev/null | grep -oE 'tokens=[0-9]+' | grep -oE '[0-9]+' | head -1)
fi
LAST_TOKENS="${LAST_TOKENS:-0}"

if [ "$LAST_TOKENS" -gt "$THRESHOLD" ] 2>/dev/null; then
    echo "" >&2
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
    echo "CONTEXT BUDGET: ~${LAST_TOKENS} tokens used (threshold: ${THRESHOLD})" >&2
    echo "  Save state:  ./harness session stop" >&2
    echo "  Commit:      git add -A && git commit -m 'wip: checkpoint'" >&2
    echo "  New session: ./harness resume" >&2
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2

    if [ "${CONTEXT_GUARD_HARD:-0}" = "1" ]; then
        exit 1
    fi
fi

exit 0
