# Plan: workflow-team

## Behavior to implement
skills/workflow-team covers claim/branch/PR gate; solo and team paths documented.

## Approach
Author skills/workflow-team/SKILL.md: shared features.json as source of truth; per-developer WIP=1;
claim-before-start; branch + PR integration gate; handoff via session-handoff + plan/evidence;
conflict resolution (first-committer-wins on features.json); contrast with solo (global WIP=1).
Link branch-convention/state-merge-convention (forward refs) + persona/step-gate.

## Files to touch
- New: .harness/skills-src/skills/workflow-team/SKILL.md
- This repo: bump submodule pointer; docs/design-docs/F06/evidence.md.

## Not in scope
- The actual branch-convention/state-merge-convention resource files (can ship later); referenced by name.
- CI/PR automation tooling.

## Risks / unknowns
- Keep solo vs team boundary crisp: solo = global WIP=1, checkpoints on current branch; team = per-assignee claim + branch + PR gate.
