# Evidence: Deep: review/quality skills (review-loop/pr-review/refactor/qa/test-strategy)

## What was built
Raised the five Phase 6/7/8 quality skills to the deep bar (`resources/skill-depth-standard.md`):

- **check-review-loop** — added `Use when:` triggers + `## One-Liner` (review is a converging loop).
  Already had a `## Gate` + fenced checklist.
- **check-pr-review** — added triggers, One-Liner (whole-change-set integration gate), and a fenced
  PR-summary output template (on-demand depth). Already had a `## Gate`.
- **check-refactor** — added triggers, One-Liner (behavior-preserving cleanup), a Bad-vs-Good
  fenced example, and a `**Gate:**` on handoff.
- **check-qa** — added triggers, One-Liner (capped converging loop), a `**Gate:**` on the loop, and
  a fenced `## Test` output template.
- **check-test-strategy** — added triggers, One-Liner (freeze types as immutable verifications), and
  a `**Gate:**` that the set is written before start. Already had a fenced add command.

All harness wiring preserved (gate hooks, persona, loop caps, cross-skill links).

## How it was verified
Immutable verification command:
```
cd .harness/skills-src && for s in check-review-loop check-pr-review check-refactor check-qa \
  check-test-strategy; do bash scripts/lint-depth.sh "$s" >/dev/null || exit 1; done && \
  bash scripts/validate.sh
```
Result: **EXIT=0**. Each skill `lint-depth` PASS (4 markers); `validate: PASS`. Relative-link
recheck across all five files: no broken links.

## Review
- [x] Each `description` has a concrete `Use when:` clause.
- [x] Each skill has a `## One-Liner` (distinct from the description).
- [x] Every skill has ≥1 explicit Gate (per-phase where multi-phase).
- [x] On-demand depth present (fenced example/output template in each).
- [x] No harness wiring removed; tables/checklists kept scannable.
- [x] Relative links re-verified; `validate.sh` PASS.

## Key decisions made
- **check-refactor got a Bad-vs-Good example** (code-touching skill) per the standard's preference;
  the others got output templates (artifact-producing skills).
- No `references/` dirs added — inline fences keep these compact skills low-bloat.
- Scope held to F32; lint-depth.sh / validate.sh / harness wiring unchanged.
