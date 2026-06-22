# Plan: Resumable bootstrap (F00 tracking feature)

## Behavior to implement
workflow-bootstrap creates+starts a bootstrap tracking feature (F00) at pre-flight so BA/design/UI progress lives in features.json + task-state and survives interrupt; doc separates setup-once (F00) from per-US phases.

## Approach
Root cause: bootstrap phases BA->design->UI produce file artifacts but seed the backlog only at
phase 4, so during 1-3 there is no in_progress feature / task-state -> `harness resume` cannot
continue after an interrupt (state lived only in chat).

Fix in skills/workflow-bootstrap/SKILL.md:
1. Pre-flight: harness add F00 "Project bootstrap" (priority 0) with a verification that
   requirements.md + design docs + a seeded US backlog + a green skeleton exist; harness start F00;
   expand .harness/tasks/F00.md.
2. Restructure into two stages:
   - Stage A (tracked under F00, runs ONCE): phases 1 BA, 2 design, 3 UI, 4 plan-tasks+skeleton.
     Tick F00 task-state boxes + commit each artifact at every phase boundary.
   - After stage A: harness verify F00 -> passing. THEN Stage B.
   - Stage B (per-US, repeated via workflow-feature): phases 5 code -> 9 ship.
3. Add an explicit Resumability note: after interrupt, `harness resume` shows F00 + its task-state next step.
WIP=1 respected: F00 passes before any US starts.

## Files to touch
- Modify: skills/workflow-bootstrap/SKILL.md
- Optionally cross-note in resources/task-state.md (setup-feature pattern).
- This repo: bump submodule; docs/design-docs/F23/evidence.md.

## Not in scope
- Changing workflow-feature / per-US loop (already resumable — each US is a feature).
- PA2 (seed backlog right after BA) - rejected as less clean for cross-cutting design/UI.

## Risks / unknowns
- F00 verification must be generic enough across stacks; keep it artifact-existence + skeleton smoke.
