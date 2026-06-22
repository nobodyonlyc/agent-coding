# Plan: Deep: design skills (database/api/detailed/ui/ux-flow)

## Behavior to implement
design-database, design-api, design-detailed, design-ui, design-ux-flow meet the depth bar
(Use-when triggers, One-Liner, Gates, on-demand depth) and pass lint-depth + validate.

## Approach
Deep-skill recipe (F31). Each already has a `## Gate`; the gaps are Use-when triggers, a
One-Liner, and an inline fenced output template (these are artifact-producing skills, so the
template is the natural on-demand-depth form). Preserve persona/step-gate/links.

## Files to touch
- `.harness/skills-src/skills/{design-database,design-api,design-detailed,design-ui,design-ux-flow}/SKILL.md`
- `docs/design-docs/F33/evidence.md`

## Not in scope
Other F3x batches; no change to lint-depth.sh / validate.sh / harness wiring.

## Risks / unknowns
Keep the doc-outline templates short; link recheck as in F31.
