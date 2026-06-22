# Evidence: Deep: workflow orchestrators (intake/bootstrap/feature/team)

## What was built
Raised the four workflow orchestrator skills to the deep-skill bar
(`resources/skill-depth-standard.md`) without bloating their already-structured bodies:

- **workflow-intake** — added `Use when:` triggers, a `## One-Liner` (classify-before-acting),
  and an explicit `**Gate:**` after Phase -1, Phase 0, Phase 0.5, Phase 0.7, Phase 0.8.
- **workflow-bootstrap** — added `Use when:` triggers, a `## One-Liner` (Stage A once / Stage B
  loop), a top-level fenced Stage-A/Stage-B command spine (on-demand-depth marker), and Gates at
  pre-flight, close-Stage-A, and Stage-B completion.
- **workflow-feature** — added `Use when:` triggers, a `## One-Liner` (one vertical slice,
  deltas-only), a fenced command spine, and a `**Gate:**` on each meaningful loop step
  (plan, design delta, plan-tasks, review, test, verify, ship).
- **workflow-team** — added `Use when:` triggers, a `## One-Liner` (git backlog is the only
  coordination layer), a fenced team-loop command spine, and Gates on mode-selection, the team
  loop, and handoff.

All existing harness wiring (persona-mode, step-gate, autonomy-mode, token-budget, task-state
links and the cross-cutting sections) was preserved.

## How it was verified
Verification command (immutable, set at `harness add`):

```
cd .harness/skills-src && for s in workflow-intake workflow-bootstrap workflow-feature \
  workflow-team; do bash scripts/lint-depth.sh "$s" >/dev/null || exit 1; done && \
  bash scripts/validate.sh
```

Result: **EXIT=0**. Per-skill `lint-depth` output (each checks the 4 deep markers — Use-when
trigger, One-Liner, ≥1 Gate, on-demand depth):

```
lint-depth [workflow-intake]: PASS
lint-depth [workflow-bootstrap]: PASS
lint-depth [workflow-feature]: PASS
lint-depth [workflow-team]: PASS
== validate: PASS ==
```

Relative-link recheck (F26–F30 discipline): all `](../…)` links in the four files resolve to
existing targets — no broken links.

## Review
Tracked checklist (self-review against the deep-skill recipe):
- [x] Each skill `description` carries a concrete `Use when:` clause.
- [x] Each skill has a `## One-Liner` capturing its core idea (not a restated description).
- [x] Every phase/stage ends in an explicit `**Gate:**` checkpoint.
- [x] On-demand depth present (top-level fenced command spine in each; bootstrap's indented
      bullet fence did not satisfy `^```` so a top-level `text` fence was added).
- [x] No harness wiring removed (persona/step-gate/token-budget/task-state links intact).
- [x] Tables kept scannable; Gates appended as one-liners rather than rewriting tables to prose.
- [x] Relative links re-verified; `validate.sh` PASS.

## Key decisions made
- **No `references/` dir added.** The standard accepts an inline fenced example *or* a
  `references/` dir; these orchestrators are already compact, so an inline command-spine fence is
  the lower-bloat choice and doubles as a quick-scan summary.
- **Gates appended, tables preserved.** The case/route tables in intake/bootstrap stay as tables;
  Gates are added as trailing one-liners so the skill stays scannable (depth-standard rule).
- **Scope held to F31.** F32–F38 batches untouched; lint-depth.sh / validate.sh / harness wiring
  unchanged.
