# Evidence: BA to-prd + architecture trade-off/ADR

## What was built
- plan-ba-analysis rewritten to deep bar with a PRD output contract (problem/users/capabilities+
  testable acceptance/out-of-scope/assumptions/open-questions); persona branching kept; phases Gated.
- design-architecture rewritten with a trade-off matrix + ADR output contract; phases components->
  stack-choice->ADR, each Gated.

## Test
F30 verification passed:
```
grep -qi prd plan-ba-analysis && grep -qiE "trade-off|ADR" design-architecture \
  && lint-depth plan-ba-analysis && lint-depth design-architecture && validate -> VERIFY-CMD PASS
```
Both lint-depth: PASS. No broken links.

## Review
- [x] BA acceptance criteria explicitly feed check-test-strategy (vagueness->weak tests closed) — wired.
- [x] architecture decision recorded as ADR (why survives) + trade-off matrix — present.
- [x] persona branching retained in BA (non-tech batched vs dev exhaustive) — verified.

## Key decisions made
- The win for weak models is an explicit OUTPUT CONTRACT per skill (PRD shape, ADR shape), not more prose.
- Adopted to-prd (MIT) PRD shape; ADR is the standard architecture-decision record.
