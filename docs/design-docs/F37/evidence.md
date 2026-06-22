# Evidence: Deep: high-risk delivery (ship-release, ship-deploy)

## What was built
Raised the two high-risk Phase 9 delivery skills to the deep bar, with emphasis on Gates (these are
irreversible/outward-facing actions):

- **ship-release** — `Use when:` triggers, `## One-Liner`, a changelog template (fence), and two
  Gates: (1) all included features `passing` + version bump justified before tag; (2) tag-push /
  publish confirmed with the user (outward-facing).
- **ship-deploy** — `Use when:` triggers, `## One-Liner`, a pre-deploy checklist (fence), and Gates
  on the always-stop confirmation and the post-deploy health/smoke + rollback. The ALWAYS-STOP
  language is unchanged — only made more explicit via the Gates.

## How it was verified
Immutable verification command:
```
cd .harness/skills-src && for s in ship-release ship-deploy; do \
  bash scripts/lint-depth.sh "$s" >/dev/null || exit 1; done && bash scripts/validate.sh
```
Result: both `lint-depth` PASS, `validate: PASS`, EXIT=0. Relative-link recheck: no broken links.

## Review
- [x] Each `description` has a `Use when:` clause.
- [x] Each skill has a `## One-Liner`.
- [x] Explicit Gates added (2 each) at the irreversible/outward-facing points.
- [x] On-demand depth = changelog template / pre-deploy checklist fence.
- [x] ALWAYS-STOP semantics preserved (not diluted); links re-verified; `validate.sh` PASS.

## Key decisions made
- Gates were placed exactly at the irreversible boundaries (tag-push, non-local deploy, post-deploy)
  — for these skills the Gate is the point of the skill.
- The fenced blocks double as copy-paste templates for the confirm prompt.
- Scope held to F37.
