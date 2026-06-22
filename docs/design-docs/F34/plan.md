# Plan: Deep: planning skills (us-backlog, plan-tasks)

## Behavior to implement
plan-us-backlog, plan-tasks meet the deep bar (Use-when triggers, One-Liner, Gates, on-demand
depth) and pass lint-depth + validate.

## Approach
Deep-skill recipe (F31). Both skills already have a `## Gate` and fenced command blocks; the only
gaps are a `Use when:` trigger clause and a `## One-Liner`. Add those without touching the rest.

## Files to touch
- `.harness/skills-src/skills/{plan-us-backlog,plan-tasks}/SKILL.md`
- `docs/design-docs/F34/evidence.md`

## Not in scope
Other F3x batches; no change to tooling/wiring.

## Risks / unknowns
Minimal — additive frontmatter + one section each. Link recheck as in F31.
