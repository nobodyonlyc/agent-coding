# Evidence: workflow-intake

## What was built
`skills/workflow-intake/SKILL.md` — the single entry point. Phases: -1 read state + empty-request
guard; 0 classify into 4 routes (new project / execute US / add feature / legacy onboard) with
ask-user confirm; 0.5 set persona (user_role) + autonomy (gated/auto) to context.json; 0.7 collab
(solo/team); 0.8 session start. Cross-cutting rules link step-gate, token-budget, persona-mode,
autonomy-mode, agent-tool-mapping.

## Test
F03 verification ran and passed:
```
test -f skills/workflow-intake/SKILL.md && grep -qi persona skills/workflow-intake/SKILL.md && bash scripts/validate.sh
-> validate: PASS ; VERIFY-CMD PASS
```
Doc/skill feature → structural test only (frontmatter name+description present, resource links
relative-correct from skills/workflow-intake/). No runtime UT/IT applies.

## Review
Self-review: frontmatter valid; all 5 resource references use ../../resources/ which resolves from
the skill dir; classification table covers the 4 cases dispatched to F04/F05/F06 (+ onboard noted
as out-of-scope per plan). Persona + autonomy + collab all persisted via harness config / task-state,
matching the resources authored in F02. No correctness or scope issues found.

## Key decisions made
- Kept classification heuristics inline (short) rather than a references/ subtree — can split later
  if it grows, honoring token-budget conciseness.
- onboard (case 4) is referenced for completeness but its workflow is outside the 20-feature scope;
  flagged in plan Not-in-scope rather than silently dropped.
