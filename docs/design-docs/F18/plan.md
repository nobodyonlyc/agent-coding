# Plan: Phase 7 Test extended

## Behavior to implement
Conditional test-type skills activate per strategy: regression (touches existing behavior), e2e (user flow), performance (NFR), security (auth/data/external).

## Approach
Four conditional test skills, each invoked only when check-test-strategy selects it:
- test-regression: re-run broader suite for touched area; guard against breaking existing behavior.
- test-e2e: drive the user-facing flow end-to-end (from design-ux-flow).
- test-performance: measure latency/throughput against the stated NFR.
- test-security: check auth/authz, input/injection, secrets, dependency/known-vuln surface.
Each records to evidence ## Test and maps to a harness verification level. Link check-test-strategy.

## Files to touch
- New: skills/test-regression, skills/test-e2e, skills/test-performance, skills/test-security (SKILL.md)
- This repo: bump submodule; docs/design-docs/F18/evidence.md.

## Not in scope
- The selector (F17). QA fix loop (F19).

## Risks / unknowns
- Each must state its activation condition so it is never run blindly nor skipped when required.
