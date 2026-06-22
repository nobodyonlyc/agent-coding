# Plan: Light: triggers+One-Liner for mechanical skills (dev-langs/ship-commit/pr/core/opt/skeleton)

## Behavior to implement
Mechanical/breadth skills get the **light** treatment only — a `Use when:` trigger clause in the
description + a `## One-Liner` — NOT the full deep bar (no forced phases/Gates/references). Targets:
dev-js-ts, dev-python, dev-go, dev-rust, ship-commit-msg, ship-pr-create, core-explore,
core-explain, core-fix, core-file-ops, opt-caveman, plan-skeleton.

## Approach
Per the rollout plan's "light recipe": add a concrete `Use when:` clause to each frontmatter
`description` and a one-line `## One-Liner`. Do not add phases/references — these are mechanical
skills where a weak model mainly needs them to trigger correctly. The F38 verification greps each
skill for a `use when` description clause + a `one-liner` marker, then runs validate.

## Files to touch
- `.harness/skills-src/skills/{dev-js-ts,dev-python,dev-go,dev-rust,ship-commit-msg,ship-pr-create,core-explore,core-explain,core-fix,core-file-ops,opt-caveman,plan-skeleton}/SKILL.md`
- `docs/design-docs/F38/evidence.md`

## Not in scope
The full deep bar — these stay light by design (tiering decision in docs/plans/deep-skill-rollout.md).
No tooling/wiring change.

## Risks / unknowns
Keep One-Liners genuinely one line; do not bloat mechanical skills. Link recheck as in F31.
