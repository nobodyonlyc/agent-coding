#!/usr/bin/env bash
# Blocks ./harness verify <id> if evidence.md is missing TEST or REVIEW sections.
# Exit 0 = allow, Exit 1 = block.

COMMAND="${CLAUDE_TOOL_INPUT_COMMAND:-${TOOL_CALL_INPUT:-$*}}"

echo "$COMMAND" | grep -qE '(\.\/harness|harness) verify' || exit 0

FEATURE_ID=$(echo "$COMMAND" | sed -E 's/.*(harness) verify[[:space:]]+(--[a-z-]+[[:space:]]+)*([A-Za-z0-9_-]+).*/\3/')
[ -z "$FEATURE_ID" ] || [ "$FEATURE_ID" = "$COMMAND" ] && exit 0

echo "$COMMAND" | grep -q -- '--override-snapshot' && exit 0

EVIDENCE="docs/design-docs/${FEATURE_ID}/evidence.md"

if [ ! -f "$EVIDENCE" ]; then
    echo "QUALITY GATE [${FEATURE_ID}]: evidence.md not found." >&2
    echo "  Run tests and record results in docs/design-docs/${FEATURE_ID}/evidence.md" >&2
    exit 1
fi

if ! grep -qi "^## test" "$EVIDENCE" 2>/dev/null; then
    echo "QUALITY GATE [${FEATURE_ID}]: evidence.md missing '## Test' section." >&2
    echo "  Record test output before calling harness verify." >&2
    exit 1
fi

if ! grep -qi "^## review" "$EVIDENCE" 2>/dev/null; then
    echo "QUALITY GATE [${FEATURE_ID}]: evidence.md missing '## Review' section." >&2
    echo "  Run /code-review and record findings before calling harness verify." >&2
    exit 1
fi

exit 0
