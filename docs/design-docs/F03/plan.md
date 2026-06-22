# Plan: workflow-intake

## Behavior to implement
skills/workflow-intake classifies an incoming prompt into 4 routes, sets user_role + autonomy + solo/team, dispatches.

## Approach
Author skills/workflow-intake/SKILL.md as the single entry point:
- Phase -1: read harness state (status/resume); empty-request guard.
- Phase 0: classify into 4 cases (new project / execute US / add feature / legacy onboard); confirm via ask-user.
- Phase 0.5: pick persona (user_role Developer|Non-Technical) + autonomy (gated|auto) and persist to context.json.
- Phase 0.7: pick collab (solo|team).
- Dispatch table to workflow-bootstrap / workflow-feature|bugfix / workflow-onboard.
Link persona-mode, autonomy-mode, step-gate, agent-tool-mapping from resources/.

## Files to touch
- New: .harness/skills-src/skills/workflow-intake/SKILL.md
- This repo: bump submodule pointer; docs/design-docs/F03/evidence.md.

## Not in scope
- The dispatched workflows themselves (bootstrap=F04, feature/bugfix=F05, team=F06).
- onboard workflow (legacy) — out of the current 20-feature scope; referenced but not built here.

## Risks / unknowns
- Must reference resources by relative path that resolves from skills/workflow-intake/.
- Classification heuristics kept short; detailed playbook can move to references/ later.
