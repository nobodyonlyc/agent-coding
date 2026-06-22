# Evidence: workflow-bootstrap

## What was built
`skills/workflow-bootstrap/SKILL.md` — new-project orchestrator. Pre-flight (persona/autonomy/collab
+ harness init + session). The 9-phase chain table maps each phase to its leaf skill and output
artifact, with step-gate between phases and persona-driven depth/language. Per-US execution hands
off to workflow-feature; deploy is always-stop. Links step-gate, persona-mode, autonomy-mode, token-budget.

## Test
F04 verification ran and passed:
```
test -f skills/workflow-bootstrap/SKILL.md && bash scripts/validate.sh -> PASS ; VERIFY-CMD PASS
```
Skill doc → structural test (frontmatter name+description, valid relative links). No runtime test applies.

## Review
Self-review: the 9-phase table matches the backlog phase mapping (BA=F07, design=F13/14, plan=F15,
code=F16, review=F08, test=F17/18, qa=F19, deploy=F09). Forward references to not-yet-built phase
skills are intentional and noted in plan Not-in-scope. Persona branch explicitly keeps review/test
full for both roles (consistent with persona-mode.md). Deploy correctly marked always-stop. No issues.

## Key decisions made
- Phase chain expressed as a delegation table (skill per phase) so bootstrap stays an orchestrator,
  not a re-implementation of phase logic.
- Per-US execution delegated to workflow-feature to avoid duplicating the execution loop in two skills.
