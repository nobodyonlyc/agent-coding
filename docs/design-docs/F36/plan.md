# Plan: Deep: component dev skills (be/fe/cli/db/batch)

## Behavior to implement
dev-be, dev-fe, dev-cli, dev-db, dev-batch meet the deep bar (Use-when triggers, One-Liner, Gate,
Bad-vs-Good example) and pass lint-depth + validate.

## Approach
Deep-skill recipe (F31). These are code-touching skills, so on-demand depth = a short
**Bad-vs-Good** fenced example per skill (the standard's preferred form). Add a `Use when:`
trigger, a `## One-Liner`, and a `**Gate:**` on the self-check/handoff. Keep examples short and
language-neutral-ish (illustrative).

## Files to touch
- `.harness/skills-src/skills/{dev-be,dev-fe,dev-cli,dev-db,dev-batch}/SKILL.md`
- `docs/design-docs/F36/evidence.md`

## Not in scope
F37/F38; language dev skills (dev-js-ts/python/go/rust) are F38; no tooling/wiring change.

## Risks / unknowns
Examples must be illustrative, not framework-locked; keep them 4-6 lines. Link recheck as in F31.
