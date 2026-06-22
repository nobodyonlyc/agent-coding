#!/usr/bin/env bash
# Blocks ./harness start <id> if plan.md is missing or still a template.
# Triggered: PreToolUse(Bash) — Claude Code
#            preToolCall Decide  — Antigravity
# Exit 0 = allow, Exit 1 = block.

COMMAND="${CLAUDE_TOOL_INPUT_COMMAND:-${TOOL_CALL_INPUT:-$*}}"

# Only act on harness start
echo "$COMMAND" | grep -qE '(\.\/harness|harness) start' || exit 0

# Extract feature ID (first token after "start" that isn't a flag)
FEATURE_ID=$(echo "$COMMAND" | sed -E 's/.*(harness) start[[:space:]]+(--[a-z-]+[[:space:]]+)*([A-Za-z0-9_-]+).*/\3/')
[ -z "$FEATURE_ID" ] || [ "$FEATURE_ID" = "$COMMAND" ] && exit 0

# --force bypasses the gate (for emergencies)
echo "$COMMAND" | grep -q -- '--force' && exit 0

PLAN="docs/design-docs/${FEATURE_ID}/plan.md"

if [ ! -f "$PLAN" ]; then
    echo "PHASE GUARD [${FEATURE_ID}]: plan.md not found." >&2
    echo "  Run: ./harness plan ${FEATURE_ID}" >&2
    exit 1
fi

# Block if plan still has template placeholders
if grep -qE '<!-- (TODO|FILL|REPLACE)' "$PLAN" 2>/dev/null; then
    echo "PHASE GUARD [${FEATURE_ID}]: plan.md still has unfilled template sections." >&2
    echo "  Fill in docs/design-docs/${FEATURE_ID}/plan.md before starting." >&2
    exit 1
fi

# Block if plan body is trivially short (< 50 non-blank chars)
CONTENT_LEN=$(grep -v '^#\|^---\|^$' "$PLAN" 2>/dev/null | tr -d '[:space:]' | wc -c | tr -d ' ')
if [ "${CONTENT_LEN:-0}" -lt 50 ]; then
    echo "PHASE GUARD [${FEATURE_ID}]: plan.md appears empty (${CONTENT_LEN} chars of content)." >&2
    echo "  Write a real plan before starting." >&2
    exit 1
fi

exit 0
