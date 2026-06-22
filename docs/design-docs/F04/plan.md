# Plan: workflow-bootstrap

## Behavior to implement
workflow-bootstrap drives a greenfield prompt through the full lifecycle (BA -> system design -> UI -> plan tasks -> code -> review -> test(multi) -> fixbug -> deploy), step-gated and persona-aware.

## Approach
Author skills/workflow-bootstrap/SKILL.md as the new-project orchestrator:
- Pre: ensure persona/autonomy/collab set (else defer to workflow-intake); harness init if needed.
- Drive phases 1-9 in order, each delegating to the phase skill (plan-ba-analysis, design-*, plan-tasks, dev-*, check-*, test-*, check-qa, ship-*).
- Between phases: step-gate confirm (gated) or logged decision (auto).
- Persona branches depth/language per phase (non-tech = requirement-level + defaults; dev = exhaustive).
- Seed the harness backlog from the US set; per-US execution hands off to workflow-feature.
Link resources: persona-mode, step-gate, autonomy-mode, token-budget.

## Files to touch
- New: .harness/skills-src/skills/workflow-bootstrap/SKILL.md
- This repo: bump submodule pointer; docs/design-docs/F04/evidence.md.

## Not in scope
- The leaf phase skills' internal content (BA=F07, design=F13/14, plan=F15, code=F16, review=F08, test=F17/18, qa=F19, deploy=F09).
- workflow-feature/bugfix (F05) — bootstrap dispatches to them per US but does not define them.

## Risks / unknowns
- Phase skills do not exist yet; SKILL.md references them by name (forward refs) — acceptable, they land in later features.
