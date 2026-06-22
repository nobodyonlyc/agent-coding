# Plan: Deep: conditional test skills (integration/regression/e2e/performance/security)

## Behavior to implement
test-integration, test-regression, test-e2e, test-performance, test-security meet the deep bar
(Use-when triggers, One-Liner, Gates, on-demand depth) and pass lint-depth + validate.

## Approach
Deep-skill recipe (F31). Each is a conditional test skill with an "Activation" clause; add a
`Use when:` trigger, a `## One-Liner`, an explicit `**Gate:**`, and an inline fenced `## Test`
output template (on-demand depth). test-integration already has a `## Gate`; the other four need
one added.

## Files to touch
- `.harness/skills-src/skills/{test-integration,test-regression,test-e2e,test-performance,test-security}/SKILL.md`
- `docs/design-docs/F35/evidence.md`

## Not in scope
Other F3x batches; no change to tooling/wiring.

## Risks / unknowns
Keep templates short; link recheck as in F31.
