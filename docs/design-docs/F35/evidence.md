# Evidence: Deep: conditional test skills (integration/regression/e2e/performance/security)

## What was built
Raised the five conditional Phase 7 test skills to the deep bar. Each gained a `Use when:` trigger
(mirroring its activation condition + the test-strategy selection), a `## One-Liner`, and an inline
fenced `## Test` output template. Explicit `**Gate:**` added to test-regression / test-e2e /
test-performance / test-security; test-integration already had a `## Gate`.

- **test-integration** — real boundary (api contract + schema), failure modes.
- **test-regression** — full suite vs baseline, reproduction test included.
- **test-e2e** — happy + failure path through the real system on seeded data.
- **test-performance** — p95/throughput vs NFR target with environment noted.
- **test-security** — authn/authz, injection, secrets, deps, data exposure on strong tier.

## How it was verified
Immutable verification command:
```
cd .harness/skills-src && for s in test-integration test-regression test-e2e test-performance \
  test-security; do bash scripts/lint-depth.sh "$s" >/dev/null || exit 1; done && \
  bash scripts/validate.sh
```
Result: all five `lint-depth` PASS, `validate: PASS`, EXIT=0. Relative-link recheck: no broken links.

## Review
- [x] Each `description` has a `Use when:` clause tied to its activation condition.
- [x] Each skill has a `## One-Liner`.
- [x] Each has an explicit Gate (4 added, integration retained).
- [x] On-demand depth = inline `## Test` output template per skill.
- [x] Links re-verified; `validate.sh` PASS.

## Key decisions made
- Output templates show the exact `## Test` evidence line the skill produces — doubles as on-demand
  depth and a copy-paste template.
- Activation clauses preserved verbatim; Use-when added alongside, not replacing them.
- Scope held to F35.
