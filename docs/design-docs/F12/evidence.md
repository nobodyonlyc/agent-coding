# Evidence: Hooks layer + config-templates

## What was built
- hooks/ (10 canonical scripts, single source): git-guard, phase-guard, quality-gate, review-gate,
  context-budget-guard, session-guard, notify (ported) + persona-gate, step-gate, caveman-budget (NEW).
- config-templates/: claude.settings.json (PreToolUse Bash + Stop hooks -> skills-src/hooks/*.sh),
  antigravity.hooks.json (preToolCall/sessionEnd map), codex.md (gate-in-skill fallback note).
- install.sh wire_hooks() (F11) merges claude.settings.json via jq.

## Test
F12 verification ran and passed:
```
test -d hooks && test -d config-templates && for h in hooks/*.sh; do bash -n "$h"; done && validate -> PASS
```
Also: all 10 hooks `bash -n` clean; claude.settings.json + antigravity.hooks.json valid JSON
(python -m json.tool). Hooks are docs-of-behavior + shell; structural + syntax tests apply, no app runtime.

## Review
Self-review: new hooks are SOFT by default (exit 0) so they nudge without breaking runs
(HARNESS_PERSONA_HARD / CONTEXT_GUARD_HARD opt-in to block); step-gate stays quiet in auto mode
(reads autonomy_mode), matching autonomy-mode.md. Templates reference scripts via the submodule path
(single source, never copied). Codex fallback keeps gates alive via ask-user + server-side harness
enforcement when no hook system exists. persona-gate/step-gate/caveman-budget directly satisfy the
three user requirements (persona lock, confirm-before-next-step, caveman token opt). No issues.

## Key decisions made
- New hooks default to soft (warn) not hard (block): a missing user_role should guide, not halt, but
  can be made blocking per-project via env var.
- Hooks are the single source in the submodule; project settings only reference them, so one
  submodule update propagates gate-logic changes to every consuming project.
