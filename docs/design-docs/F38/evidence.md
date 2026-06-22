# Evidence: Light: triggers+One-Liner for mechanical skills (dev-langs/ship-commit/pr/core/opt/skeleton)

## What was built
Applied the **light** treatment (per the tiering decision in docs/plans/deep-skill-rollout.md) to
12 mechanical/breadth skills: a concrete `Use when:` clause in each frontmatter `description` + a
one-line `## One-Liner`. No phases/Gates/references were forced — these are skills a weak model
mainly needs to *trigger* correctly, so full depth would be bloat.

Skills updated: dev-js-ts, dev-python, dev-go, dev-rust, ship-commit-msg, ship-pr-create,
core-explore, core-explain, core-fix, core-file-ops, opt-caveman, plan-skeleton.

## How it was verified
Immutable verification command (light bar = Use-when + One-Liner markers, then validate):
```
cd .harness/skills-src && for s in dev-js-ts dev-python dev-go dev-rust ship-commit-msg \
  ship-pr-create core-explore core-explain core-fix core-file-ops opt-caveman plan-skeleton; do \
  grep -qiE "^description:.*use when" skills/$s/SKILL.md && \
  grep -qiE "one[- ]?liner" skills/$s/SKILL.md || exit 1; done && bash scripts/validate.sh
```
Result: all 12 OK, `validate: PASS`, EXIT=0. Relative-link recheck: no broken links.

## Review
- [x] Each of the 12 `description`s has a `Use when:` clause.
- [x] Each of the 12 has a one-line `## One-Liner`.
- [x] No deep-bar bloat added (no forced phases/Gates/references) — light tier by design.
- [x] Links re-verified; `validate.sh` PASS.

## Key decisions made
- Honored the rollout plan's LIGHT vs DEEP tiering: mechanical skills stay light on purpose.
- dev-* language skills got One-Liners framing them as the "how" layer composing under a component
  skill (the "what"), reinforcing how they are meant to be used together.
- Scope held to F38. This completes the deep-skill rollout backlog (F31–F38).
