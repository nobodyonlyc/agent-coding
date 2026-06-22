# Plan: Phase 6 Review

## Behavior to implement
Review skills produce real findings recorded to evidence ## Review; gate blocks verify on placeholders.

## Approach
- check-code-review: review the child-task diff for correctness/security/scope; record real findings
  (or "No issues found" with justification) to evidence ## Review.
- check-pr-review: review an integration PR (team mode) before merge.
- check-refactor: targeted reuse/simplification pass (quality only, no bug hunt).
All three explain the review-gate/quality-gate hook contract (## Review must be non-placeholder).
Link step-gate, persona, token-budget.

## Files to touch
- New: skills/check-code-review, skills/check-pr-review, skills/check-refactor (SKILL.md)
- This repo: bump submodule; docs/design-docs/F08/evidence.md.

## Not in scope
- Test execution (F17/18), QA loop (F19). Review hands off to test.

## Risks / unknowns
- Must keep review a HARD gate: findings written to evidence, no placeholder text (review-gate.sh enforces).
