# Evidence: workflow-feature + workflow-bugfix

## What was built
- `skills/workflow-feature/SKILL.md` — 9-step US execution loop (claim/plan -> BA delta -> design
  delta -> plan tasks + freeze test-strategy -> code -> review -> test -> verify -> ship), solo/team
  aware, persona + step-gate, WIP=1 scope discipline.
- `skills/workflow-bugfix/SKILL.md` — reproduce-first loop (failing test -> locate -> minimal fix ->
  mandatory regression -> review -> verify).

## Test
F05 verification ran and passed:
```
test -f skills/workflow-feature/SKILL.md && test -f skills/workflow-bugfix/SKILL.md && bash scripts/validate.sh
-> PASS ; VERIFY-CMD PASS
```
Skill docs -> structural test (frontmatter + relative links). No runtime test applies.

## Review
Self-review: feature vs bugfix are clearly differentiated (feature = full chain to add capability;
bugfix = reproduce-first, regression mandatory, minimal footprint). Both reuse check-test-strategy
and the same review/verify gates, so quality is identical. Team path correctly delegates to
workflow-team. Links resolve from skills/<name>/. No correctness or scope issues.

## Key decisions made
- bugfix enforces "failing test before fix" + always-on regression, encoding the user's requirement
  that test type depends on the change (a bug edits existing behavior -> regression required).
- Both skills delegate phase internals to leaf skills rather than duplicating them.
