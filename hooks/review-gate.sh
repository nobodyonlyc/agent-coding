#!/usr/bin/env bash
# Blocks verify if evidence.md REVIEW section is a placeholder (not real findings).
# Runs after quality-gate.sh — assumes evidence.md and ## Review section exist.
# Exit 0 = allow, Exit 1 = block.

COMMAND="${CLAUDE_TOOL_INPUT_COMMAND:-${TOOL_CALL_INPUT:-$*}}"

echo "$COMMAND" | grep -qE '(\.\/harness|harness) verify' || exit 0

FEATURE_ID=$(echo "$COMMAND" | sed -E 's/.*(harness) verify[[:space:]]+(--[a-z-]+[[:space:]]+)*([A-Za-z0-9_-]+).*/\3/')
[ -z "$FEATURE_ID" ] || [ "$FEATURE_ID" = "$COMMAND" ] && exit 0

echo "$COMMAND" | grep -q -- '--override-snapshot' && exit 0

EVIDENCE="docs/design-docs/${FEATURE_ID}/evidence.md"
[ -f "$EVIDENCE" ] || exit 0

# Extract lines under ## Review section
REVIEW_CONTENT=$(awk '/^## [Rr]eview/,/^## [^R]/' "$EVIDENCE" 2>/dev/null | grep -v '^##')

REVIEW_LEN=$(echo "$REVIEW_CONTENT" | tr -d '[:space:]' | wc -c | tr -d ' ')

if [ "${REVIEW_LEN:-0}" -lt 30 ]; then
    echo "REVIEW GATE [${FEATURE_ID}]: ## Review section in evidence.md is too sparse (${REVIEW_LEN} chars)." >&2
    echo "  Run /code-review and record real findings (or 'No issues found' with justification)." >&2
    exit 1
fi

# Check for obvious placeholder text
if echo "$REVIEW_CONTENT" | grep -qi "TODO\|FILL IN\|placeholder\|N/A$"; then
    echo "REVIEW GATE [${FEATURE_ID}]: ## Review section still contains placeholder text." >&2
    exit 1
fi

exit 0
