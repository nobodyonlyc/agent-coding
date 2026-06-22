# Plan: Roll the remaining leaf skills up to the depth standard

> Handoff plan for a **future session**. Pick up with `./harness status` → start the lowest-numbered
> `not_started` F3x feature → follow the recipe below. Standard: `resources/skill-depth-standard.md`.

## Current state (measured 2026-06-22)
`lint-depth` over all 45 skills: **6 PASS, 39 thin.**
Already deep: check-code-review, workflow-bugfix, test-unit, plan-ba-analysis, design-architecture,
check-security-review.

## Tiering decision (NOT every skill must be full-deep)
The standard is **opt-in**; mechanical/fast skills stay lighter on purpose.

- **DEEP** (full bar: Use-when triggers · One-Liner · phases+Gates · Bad/Good or `references/`) —
  judgment skills where a weak model is most likely to drift. Must pass `lint-depth`.
- **LIGHT** (triggers + One-Liner only) — mechanical/reference skills. A weak model mainly needs them
  to *trigger* correctly; full phases would be bloat.

## Feature breakdown (seeded in the backlog as F31–F38)

| Feat | Tier | Skills | Pri |
|---|---|---|---|
| **F31** | deep | workflow-intake, workflow-bootstrap, workflow-feature, workflow-team | 1 |
| **F32** | deep | check-review-loop, check-pr-review, check-refactor, check-qa, check-test-strategy | 1 |
| **F33** | deep | design-database, design-api, design-detailed, design-ui, design-ux-flow | 1 |
| **F34** | deep | plan-us-backlog, plan-tasks | 2 |
| **F35** | deep | test-integration, test-regression, test-e2e, test-performance, test-security | 1 |
| **F36** | deep | dev-be, dev-fe, dev-cli, dev-db, dev-batch | 2 |
| **F37** | deep | ship-release, ship-deploy (high-risk/irreversible → deserve full structure) | 1 |
| **F38** | light | dev-js-ts, dev-python, dev-go, dev-rust, ship-commit-msg, ship-pr-create, core-explore, core-explain, core-fix, core-file-ops, opt-caveman, plan-skeleton | 3 |

Each F31–F37 verification = every named skill passes `lint-depth` + `validate`. F38 = every named
skill has a `Use when:` trigger + a One-Liner + `validate` (no full bar).

## Per-skill upgrade recipe (deep)
1. Read the current SKILL.md + `resources/skill-depth-standard.md` + the closest done example
   (check-code-review / workflow-bugfix / design-architecture).
2. Add to frontmatter `description`: a `Use when:` clause (concrete trigger situations).
3. Add `## One-Liner` (the core idea / critical insight).
4. Restructure the body into phases, **each ending in a `**Gate:**`**.
5. Add either a **Bad vs Good** fenced example (code-touching skills) or an **output contract** /
   `references/` files (artifact-producing skills). Push long checklists into `references/`.
6. Keep all existing harness wiring (persona, step-gate, token-budget, test-strategy, task-state links).
7. `bash scripts/lint-depth.sh <skill>` → PASS; re-audit relative links; `bash scripts/validate.sh`.
8. Record findings in evidence `## Review` as the tracked checklist; verify the feature.

## Recipe (light)
Add only a `Use when:` trigger clause to the description + a one-line `## One-Liner`. Do not force
phases/references. (Optional tooling: add a `lint-depth.sh --light <skill>` mode that checks just
these two; until then the feature verification greps for them.)

## Notes / cautions
- Mind WIP=1: one feature in_progress at a time; the per-skill loop is internal to a feature.
- Some target skills are forward-referenced by done skills; keep links valid (run the link recheck
  used in F26–F30 evidence).
- Workflows (F31) are orchestrators, not leaf skills, but benefit most from gates — included first.
- Don't bloat for its own sake: a skill is "deep enough" when a weak model can execute it without
  guessing, not when it is long.
