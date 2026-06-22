# Plan: Hooks layer + config-templates + per-agent wiring

## Behavior to implement
hooks/ holds all gate scripts incl persona-gate/step-gate/caveman-budget; config-templates wire them per agent; bash -n clean.

## Approach
Author hooks/ (canonical, single source):
- git-guard, phase-guard, quality-gate, review-gate, context-budget-guard, session-guard, notify (ported)
- persona-gate (block start when user_role unset, soft), step-gate (Stop: remind confirm next step),
  caveman-budget (Stop: suggest caveman when token usage high) -- NEW
config-templates/: claude.settings.json (PreToolUse Bash + Stop hooks -> skills-src/hooks/*.sh),
antigravity.hooks.json (preToolCall/session_end map), codex.md (note: gate-in-skill where no hooks).
install.sh wire_hooks() (F11) merges claude.settings.json.

## Files to touch
- New: hooks/*.sh (10), config-templates/{claude.settings.json,antigravity.hooks.json,codex.md}
- Remove hooks/.gitkeep, config-templates/.gitkeep
- This repo: bump submodule; docs/design-docs/F12/evidence.md.

## Not in scope
- Rewiring THIS project's existing root hooks/ (the project keeps its own copy; harness-skills hooks
  are the reusable source for new projects).

## Risks / unknowns
- All hooks must be bash -n clean (validator enforces). Keep new hooks soft (exit 0) to avoid breaking runs.
