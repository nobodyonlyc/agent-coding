# Evidence: Deep: planning skills (us-backlog, plan-tasks)

## What was built
Both Phase 1/4 planning skills already had a `## Gate` and fenced command blocks; added the two
missing deep markers to each:

- **plan-us-backlog** — `Use when:` triggers + `## One-Liner` (vertical USs seeded into the backlog
  as the source of truth).
- **plan-tasks** — `Use when:` triggers + `## One-Liner` (split into child-tasks, freeze the
  test-strategy as immutable verifications before start).

No other content changed.

## How it was verified
Immutable verification command:
```
cd .harness/skills-src && for s in plan-us-backlog plan-tasks; do \
  bash scripts/lint-depth.sh "$s" >/dev/null || exit 1; done && bash scripts/validate.sh
```
Result: both `lint-depth` PASS, `validate: PASS`, EXIT=0. Relative-link recheck: no broken links.

## Review
- [x] Each `description` has a `Use when:` clause.
- [x] Each skill has a `## One-Liner`.
- [x] Existing Gate + fenced command blocks retained.
- [x] Links re-verified; `validate.sh` PASS.

## Key decisions made
- Minimal additive change — these two skills only lacked the trigger clause + One-Liner.
- Scope held to F34.
