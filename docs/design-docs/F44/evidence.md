# Evidence: Caveman level-selection matrix (lite/full/ultra per traffic type)

## What was built
A concrete answer to "which part uses which level", added to the standing caveman rule:

- **resources/token-budget.md** §1 — replaced the one-line Levels note with a **"Level selection"**
  matrix mapping each inter-agent traffic type to a level, plus an explicit "no caveman — full prose"
  route for judgment-critical content. Spells out that caveman level `full` (terse telegraphic) is
  NOT the same as "full prose" (uncompressed). Default-when-unsure line included.
- **skills/opt-caveman/SKILL.md** — Levels section now points to the matrix and summarizes the
  routing in one paragraph.
- **skills/core-explore/SKILL.md** — one-line hint: bulk file/grep/search dumps → `ultra`.
- **skills/dev-batch/SKILL.md** — one-line hint: item lists/progress data → `ultra`, run summaries → `full`.

### The mapping (the analysis requested)
| Traffic | Level | Rationale |
|---|---|---|
| Subagent task instructions (reviewer/tester/dev/expert prompts) | `lite` | clarity matters; drop only filler |
| Phase handoff notes + task-state checkpoints | `full` | routine, low-ambiguity status |
| Plan/split/scaffold instructions | `full` | mechanical + structured |
| Bulk data dumps (core-explore results, dev-batch item lists, raw logs) | `ultra` | high-volume, low-ambiguity |
| Returned structured results (test output, metrics) | `full`→`ultra` | data, not prose |
| Judgment artifacts (review/security/design-ADR/requirements/UX-e2e reasoning) | **no caveman, full prose** + `strong` | compression could weaken a gate |
| User-facing output | **no caveman** unless opted in | persona/tone |

## How it was verified
Immutable verification command:
```
cd .harness/skills-src && grep -qi "Level selection" resources/token-budget.md \
  && grep -qi "lite" resources/token-budget.md && grep -qi "ultra" resources/token-budget.md \
  && grep -qi "full prose" resources/token-budget.md && grep -qi level skills/opt-caveman/SKILL.md \
  && bash scripts/validate.sh
```
Result: **EXIT=0**, `validate: PASS`. Relative-link recheck on the 3 edited skills: no broken links.

## Review
- [x] token-budget.md has a Level selection matrix covering lite/full/ultra + a no-caveman/full-prose route.
- [x] The level-`full` vs full-prose naming ambiguity is called out explicitly.
- [x] opt-caveman references the matrix; core-explore/dev-batch carry one-line hints.
- [x] Judgment-critical content routed to full prose (quality hard-rule respected).
- [x] validate.sh PASS; links re-verified.

## Key decisions made
- Map by **what the traffic is** (instruction vs handoff vs bulk data vs judgment), not by size —
  size only escalates within the data row.
- Kept the per-skill hints to a single line (matrix is the source of truth) to avoid bloat.
- No trace logging (user declined).
