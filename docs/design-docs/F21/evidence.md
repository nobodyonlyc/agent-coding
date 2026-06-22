# Evidence: Task-state maintenance

## What was built
Root-cause fix for "task-state checklists never get ticked after a feature passes":
- resources/task-state.md — convention making explicit that the file is AGENT-maintained (CLI only
  creates at start + reads at resume; never ticks), with the full template + per-phase checkpoint lifecycle.
- hooks/task-state-guard.sh — soft backstop: warns on `harness verify <id>` when implementation/tests/
  review boxes are still unticked, and on Stop when an in_progress feature shows no [x]/[/] progress.
- Each workflow-* SKILL.md + resources/step-gate.md now require updating + committing the task-state
  file at every phase boundary (part of the step-gate beat).
- config-templates (claude.settings.json + antigravity.hooks.json) wire task-state-guard for both agents.
- Demonstrated on F21 itself: .harness/tasks/F21.md expanded to the full template and ticked.

## Test
F21 verification ran and passed:
```
test -f resources/task-state.md && test -f hooks/task-state-guard.sh && bash -n hooks/task-state-guard.sh \
  && for w in 5 workflows; do grep -qi task-state ...; done && grep -q task-state-guard config-templates/claude.settings.json && validate
-> VERIFY-CMD PASS
```
Hook behavior tested directly:
- verify of stale F03 (all [ ]) -> emits TASK-STATE GUARD warning (correct).
- verify of F21 (impl/review [x]) -> no warning (correct).
JSON templates valid (python -m json.tool). All hooks bash -n clean.

## Review
Self-review found and fixed a real bug: `local id="$1" f="$TASKS_DIR/$id.md"` on one line evaluated
`$id` before assignment (bash same-line gotcha), so `f` resolved to `.harness/tasks/.md` and the guard
silently never fired. Split into two `local` statements; re-tested -> warns correctly. This is exactly
the class of silent-drift the feature targets. Hook kept soft (exit 0) so it nudges, never blocks.
No other issues.

## Key decisions made
- Kept the file agent-maintained (declined auto-tick on verify) per task-state-convention; the hook is
  a backstop, not an auto-updater.
- task-state checkpoint folded into the step-gate beat so "confirm next step" and "update task-state"
  happen together — one less thing to forget.
- Historical F01-F20 task files left as-is (passing already); fix targets future runs.
