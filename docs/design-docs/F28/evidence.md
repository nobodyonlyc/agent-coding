# Evidence: test-unit TDD tracer-bullet

## What was built
Rewrote test-unit to the depth bar adopting tdd-workflow (MIT): One-Liner; Core Philosophy
(behavior-through-public-interface; anti-pattern horizontal slicing); phases Plan/Tracer-bullet/
Incremental-loop each with a Gate; Bad/Good example (implementation-coupled vs behavior test).
Kept harness wiring (unit: verification, check-test-strategy).

## Test
F28 verification passed:
```
grep -qiE "tracer|red.?green|public interface" test-unit && lint-depth test-unit && validate -> VERIFY-CMD PASS
```
lint-depth test-unit: PASS. No broken links.

## Review
- [x] "Use when:" trigger present for lint-depth — yes.
- [x] Bad/Good shows behavior vs implementation coupling — present.
- [x] each phase has a Gate; deterministic-test rules retained — verified.

## Key decisions made
- Adopted vertical-slice TDD so weak models stop bulk-writing tests against imagined behavior; kept
  test-unit as the always-required type that gates the broader suite.
