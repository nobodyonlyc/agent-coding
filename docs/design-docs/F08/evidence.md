# Evidence: Phase 6 Review

## What was built
- check-code-review — correctness/security/contract/scope/clarity dimensions; records real findings
  to evidence ## Review; hard gate (review-gate + quality-gate hooks reject placeholders/missing section).
- check-pr-review — team integration gate over the full PR (tests present, migration safety, features.json).
- check-refactor — behavior-preserving cleanup (reuse/simplification/clarity); not a bug hunt.

## Test
F08 verification ran and passed:
```
for s in check-code-review check-pr-review check-refactor; do test -f skills/$s/SKILL.md; done && validate -> PASS
```
Skill docs -> structural test. No runtime test.

## Review
Self-review: review is explicitly a HARD gate tied to the existing hooks (quality-gate requires
## Review section; review-gate rejects placeholder/N/A). check-code-review (bugs) vs check-refactor
(quality, behavior-preserving) are cleanly separated. PR review is named as the team merge gate.
"Use strong tier, never downgrade review" enforces the token-budget quality-outranks-cost rule. No issues.

## Key decisions made
- Split bug-finding (check-code-review) from quality cleanup (check-refactor) so a refactor never
  hides a behavior change.
- Review findings live in evidence ## Review so the harness hooks can mechanically enforce the gate.
