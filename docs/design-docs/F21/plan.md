# Plan: Task-state maintenance

## Behavior to implement
Workflows update .harness/tasks/<id>.md at each phase boundary; a soft task-state-guard hook warns when task-state lags feature status; wired per agent.

## Approach
Root cause: harness CLI only creates (at start) and reads (at resume) the task-state file; it never
ticks boxes. Updating is the workflow/agent's job per task-state-convention, but the F03-F06 workflow
skills never did it and no hook flagged the drift.

Fix:
1. resources/task-state.md - concise convention: after start expand the minimal scaffold to the full
   template (Mode/Collab/Acceptance/Phase checklist/Decisions/Next step); at each phase boundary tick
   [ ]->[/]->[x], update Current phase + Next step, commit. Never tick ahead.
2. hooks/task-state-guard.sh - soft backstop: on `harness verify <id>` warn if implementation/tests
   boxes still unticked; on Stop warn if an in_progress feature's task-state has no [x]/[/] progress.
3. Update each workflow-* SKILL.md + step-gate.md to reference the task-state checkpoint.
4. Wire task-state-guard into config-templates (claude.settings.json + antigravity.hooks.json).

## Files to touch
- New: resources/task-state.md, hooks/task-state-guard.sh
- Modify: skills/workflow-{intake,bootstrap,feature,bugfix,team}/SKILL.md, resources/step-gate.md,
  config-templates/claude.settings.json, config-templates/antigravity.hooks.json
- This repo: bump submodule; docs/design-docs/F21/evidence.md.

## Not in scope
- Retroactively ticking the 20 historical (passing) task files - low value.
- Auto-tick on verify (option c, declined) - keep file agent-maintained.

## Risks / unknowns
- Hook must stay soft (exit 0) and parse both the minimal binary template and the expanded template.
