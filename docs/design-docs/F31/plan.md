# Plan: Deep: workflow orchestrators (intake/bootstrap/feature/team)

## Behavior to implement
workflow-intake, workflow-bootstrap, workflow-feature, workflow-team meet the depth bar (Use-when triggers, One-Liner, phases+Gates) and pass lint-depth.

## Approach
Per the deep-skill recipe (`resources/skill-depth-standard.md`), enrich each of the four
orchestrator SKILL.md files **without bloating**. These skills are already well-structured; the
gap is the four lint-depth markers. For each:
1. Add a `Use when:` clause to the frontmatter `description` (concrete trigger situations).
2. Add a `## One-Liner` capturing the orchestrator's core idea.
3. Make each existing phase end in an explicit `**Gate:**` checkpoint.
4. Ensure on-demand depth: keep/keep-adding an inline fenced block (intake & bootstrap already
   have bash fences; feature & team need a fenced block or references dir).
Preserve all existing harness wiring (persona, step-gate, token-budget, task-state, links).

## Files to touch
- `.harness/skills-src/skills/workflow-intake/SKILL.md`
- `.harness/skills-src/skills/workflow-bootstrap/SKILL.md`
- `.harness/skills-src/skills/workflow-feature/SKILL.md`
- `.harness/skills-src/skills/workflow-team/SKILL.md`
- `docs/design-docs/F31/evidence.md` (tracked review checklist + verify output)

## Not in scope
- The other F3x batches (F32–F38) — separate features.
- No change to lint-depth.sh, validate.sh, or harness wiring.
- No mirror/install step beyond what `validate.sh` checks.

## Risks / unknowns
- Adding Gates must not turn scannable tables into prose. Keep tables; append a one-line Gate
  after each phase block.
- Relative links must stay valid (re-run the link recheck used in F26–F30).
