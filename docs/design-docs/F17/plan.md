# Plan: Phase 7 Test core

## Behavior to implement
test-strategy selects required test types from system requirements; UT always, IT when cross-component. Selection recorded into the task's verifications.

## Approach
- check-test-strategy: the selector. Reads task characteristics (cross-component? touches existing
  behavior? user flow? NFR? auth/data/external?) and outputs the required set: UT always, plus
  IT/regression/e2e/performance/security conditionally. Output becomes the task's --verifications.
- test-unit: how to write/run UT for the task.
- test-integration: how to write/run IT across components/external deps.
check-test-strategy must mention regression/e2e/performance/security (verification greps these).
Link plan-tasks (freezing), persona, token-budget.

## Files to touch
- New: skills/check-test-strategy, skills/test-unit, skills/test-integration (SKILL.md)
- This repo: bump submodule; docs/design-docs/F17/evidence.md.

## Not in scope
- regression/e2e/performance/security skills themselves (F18); referenced by the selector.

## Risks / unknowns
- The selector must align exactly with the matrix in CATEGORIES.md and plan-tasks.
