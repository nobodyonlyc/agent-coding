# Plan: Deep: review/quality skills (review-loop/pr-review/refactor/qa/test-strategy)

## Behavior to implement
check-review-loop, check-pr-review, check-refactor, check-qa, check-test-strategy meet the deep
bar (Use-when triggers, One-Liner, phases+Gates, on-demand depth) and pass lint-depth + validate.

## Approach
Same deep-skill recipe as F31 (`resources/skill-depth-standard.md`), applied without bloat:
1. Add a `Use when:` clause to each frontmatter `description`.
2. Add a `## One-Liner` capturing each skill's core idea.
3. Make each phase/section end in an explicit `**Gate:**` (several already have a `## Gate`).
4. Ensure on-demand depth: keep/add an inline fenced example or output template.
Preserve all harness wiring (persona, gate hooks, links, loop caps).

## Files to touch
- `.harness/skills-src/skills/{check-review-loop,check-pr-review,check-refactor,check-qa,check-test-strategy}/SKILL.md`
- `docs/design-docs/F32/evidence.md`

## Not in scope
F33–F38 (separate features); no change to lint-depth.sh / validate.sh / harness wiring.

## Risks / unknowns
- Keep tables/checklists scannable; append Gates as one-liners.
- Relative links must stay valid (link recheck as in F31).
