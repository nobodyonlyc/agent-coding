# Evidence: Deep: design skills (database/api/detailed/ui/ux-flow)

## What was built
Raised the five Phase 2/3 design skills to the deep bar. Each already had a `## Gate`; added to
each: a `Use when:` trigger clause, a `## One-Liner`, and an inline fenced **output template** (the
natural on-demand-depth form for artifact-producing skills):

- **design-database** — schema/keys/indexes/migrations template.
- **design-api** — operation/contract/error-model/versioning template.
- **design-detailed** — component/algorithm/pattern/failure template.
- **design-ui** — per-screen mockup/states/components/approval template.
- **design-ux-flow** — journey/screen-map/transitions/e2e-candidate template.

Persona, step-gate, always-stop (destructive migrations), and cross-skill links preserved.

## How it was verified
Immutable verification command (lint-depth on all five + validate):
```
cd .harness/skills-src && for s in design-database design-api design-detailed design-ui \
  design-ux-flow; do bash scripts/lint-depth.sh "$s" >/dev/null || exit 1; done && \
  bash scripts/validate.sh
```
Result: all five `lint-depth` PASS, `validate: PASS`, EXIT=0. Relative-link recheck: no broken links.

## Review
- [x] Each `description` has a `Use when:` clause.
- [x] Each skill has a `## One-Liner`.
- [x] Each retains an explicit Gate.
- [x] On-demand depth = inline output template per skill.
- [x] Persona/step-gate/always-stop wiring intact; links re-verified; `validate.sh` PASS.

## Key decisions made
- Output templates (not Bad-vs-Good) chosen — these skills produce design docs, not code.
- Templates kept short (doc outlines) to avoid bloat per the standard.
- Scope held to F33.
