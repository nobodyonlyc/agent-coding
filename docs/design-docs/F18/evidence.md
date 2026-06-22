# Evidence: Phase 7 Test extended

## What was built
Four conditional test skills, each stating its activation condition and mapping to a harness
verification level:
- test-regression (touches existing behavior; mandatory for bugfix; reproduction test included)
- test-e2e (user-facing flow from design-ux-flow; happy + key failure path)
- test-performance (only when an NFR is stated; p50/p95/p99 vs target)
- test-security (auth/secrets/data/external; authn/authz, injection, secrets, deps, data exposure)

## Test
F18 verification ran and passed:
```
for s in test-regression test-e2e test-performance test-security; do test -f skills/$s/SKILL.md; done && validate -> PASS
```
Skill docs -> structural test. No runtime test.

## Review
Self-review: each skill leads with its activation condition (never run blindly, never skipped when
required), matching the selector in F17. Ordering respected (e2e after unit+integration). "Don't
narrow the suite to pass" (regression) and "never downgrade security to save tokens" enforce the
quality-over-cost rule. Security note keeps exploitation within authorized scope. No issues.

## Key decisions made
- Activation conditions are stated in each skill (not only the selector) so a skill invoked directly
  still self-checks whether it should run.
- Performance allows renegotiating the NFR only as a logged decision (auditable), never silently.
