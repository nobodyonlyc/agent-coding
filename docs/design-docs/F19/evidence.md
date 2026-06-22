# Evidence: Phase 8 Fixbug/QA

## What was built
skills/check-qa/SKILL.md — the QA loop: run the task's selected test set; on failure add a
reproducing test + minimal fix + regression, re-run until green; capped (3-5 iters) with ask-user
escalation; never relax tests to force green. Persona-aware reporting.

## Test
F19 verification ran and passed:
```
test -f skills/check-qa/SKILL.md && validate -> PASS
```
Skill doc -> structural test. No runtime test.

## Review
Self-review: loop is capped (runaway protection per autonomy-mode) and escalates rather than looping
forever; "never delete/relax a test to pass" enforces gate integrity; reuses workflow-bugfix
reproduce-first and the F17 selected set. No issues.

## Key decisions made
- check-qa orchestrates existing test/review skills rather than re-implementing them; its value is the
  capped fix loop + escalation contract.
