# Plan: Phase 4 Plan Tasks

## Behavior to implement
Splits a US into child-tasks F<id>-T<n>, scaffolds skeleton, and freezes the per-task test-strategy into immutable verifications before start.

## Approach
- plan-tasks: split a US into vertical child-tasks; run check-test-strategy to pick required test
  types per task; write those as the task's --verifications BEFORE harness start (immutable after).
- plan-skeleton: generate the minimal project/file skeleton for greenfield so dev-* has a frame.
Must grep-contain "test-strategy" in plan-tasks (verification). Link check-test-strategy, persona, step-gate.

## Files to touch
- New: skills/plan-tasks/SKILL.md, skills/plan-skeleton/SKILL.md
- This repo: bump submodule; docs/design-docs/F15/evidence.md.

## Not in scope
- The test-strategy selector internals (check-test-strategy ships in F17); referenced here.
- Code implementation (F16).

## Risks / unknowns
- Must make the immutability linkage explicit: verifications are set at plan time and locked at start.
