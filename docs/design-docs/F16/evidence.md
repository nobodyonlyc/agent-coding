# Evidence: Phase 5 Code

## What was built
- Five dev skills: dev-be, dev-fe, dev-cli, dev-db, dev-batch — each implements the thinnest slice of
  a child-task per design docs + conventions, self-checks, then hands to review + the frozen test types.
- resources/conventions/{typescript-node,python,go}.md — language guides (strictness, errors, tests, no-secrets).

## Test
F16 verification ran and passed:
```
for s in dev-be dev-fe dev-cli dev-db dev-batch; do test -f skills/$s/SKILL.md; done && test -d resources/conventions && validate -> PASS
```
Skill+convention docs -> structural test. No runtime test (these describe how code is written).

## Review
Self-review: each dev skill names the downstream tests it triggers (dev-db->regression+IT,
dev-fe->UT+e2e, dev-batch->IT+performance), keeping phase 5 coupled to the phase-7 strategy.
WIP=1 scope discipline and always-stop on destructive migrations are restated. Conventions enforce
no-secrets + tests-green-before-review. No issues.

## Key decisions made
- Shipped resources/conventions/ here (not F02) because conventions belong to the code phase and the
  F16 verification asserts the directory exists.
- dev skills stay declarative (how to implement) and delegate quality to check-*/test-* rather than
  duplicating gates.
