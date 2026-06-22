# Plan: Deep: high-risk delivery (ship-release, ship-deploy)

## Behavior to implement
ship-release, ship-deploy meet the deep bar (Use-when triggers, One-Liner, phases+Gates,
on-demand depth) and pass lint-depth + validate.

## Approach
Deep-skill recipe (F31). These are high-risk/irreversible, so Gates matter most. Add a `Use when:`
trigger, a `## One-Liner`, explicit `**Gate:**` checkpoints (per-step for ship-deploy's procedure),
and an inline fenced template (changelog template / deploy pre-check checklist). Preserve the
always-stop wiring exactly — do not weaken it.

## Files to touch
- `.harness/skills-src/skills/{ship-release,ship-deploy}/SKILL.md`
- `docs/design-docs/F37/evidence.md`

## Not in scope
F38; no tooling/wiring change; the always-stop semantics are unchanged (only made more explicit).

## Risks / unknowns
Must not dilute always-stop language. Link recheck as in F31.
