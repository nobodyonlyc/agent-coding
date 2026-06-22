# Evidence: Phase 7 Test core

## What was built
- check-test-strategy — the selector: a matrix mapping task characteristics to the required test set
  (UT always; IT/regression/e2e/performance/security conditionally) and emitting them as immutable
  --verifications at plan time.
- test-unit — always-required isolated tests for logic + edge cases.
- test-integration — cross-boundary tests against real(istic) deps for tasks that cross components.

## Test
F17 verification ran and passed:
```
test -f check-test-strategy && test -f test-unit && test -f test-integration \
  && grep -qiE "regression|e2e|performance|security" check-test-strategy && validate -> PASS
```
Skill docs -> structural test. No runtime test.

## Review
Self-review: the selector matrix matches CATEGORIES.md and plan-tasks exactly (same six types, same
conditions). "Under-selecting is a quality failure, include when borderline" enforces quality-over-cost.
UT is a prerequisite for IT and the rest; ordering (units first) is stated. Each type maps to a
harness verification level (unit:/integration:). No issues.

## Key decisions made
- The selector emits the actual --verifications, making "test type depends on system requirement" a
  mechanical, enforced outcome rather than a guideline.
- Borderline conditions resolve toward MORE testing, never less.
