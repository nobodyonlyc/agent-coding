# Plan: Caveman level-selection matrix (lite/full/ultra per traffic type)

## Behavior to implement
token-budget.md gains a "Level selection" matrix mapping each inter-agent traffic type to a caveman
level (lite/full/ultra), and explicitly routing judgment-critical content to **no caveman (full
prose)**; opt-caveman references the matrix; the highest-volume skills carry a one-line level hint;
validate passes.

## The mapping (my analysis)
Caveman levels: `lite` = drop filler, keep full sentences; `full` = terse telegraphic; `ultra` =
max compression. Naming care: caveman level `full` ≠ "full prose" (uncompressed). Mapping by what
the traffic *is*:

| Inter-agent traffic | Level | Why |
|---|---|---|
| Subagent **task instructions** (reviewer/tester/dev/expert prompts) | `lite` | instructions need clarity; only filler goes |
| Phase **handoff notes** + task-state checkpoints | `full` | routine, low-ambiguity status |
| **Plan/split/scaffold** instructions (plan-tasks, plan-skeleton) | `full` | mechanical + structured |
| **Bulk data passing**: file/grep/search dumps (core-explore), batch item lists (dev-batch), raw log excerpts | `ultra` | high-volume, low-ambiguity |
| Returned **structured results** (test output, metrics tables) | `full`→`ultra` | data, not prose |
| **Judgment artifacts**: review-finding rationale, security analysis, design trade-offs/ADR, requirements, UX/e2e reasoning | **no caveman (full prose)** + `strong` | compression risks weakening a gate — hard rule wins |
| **User-facing output** | **no caveman** unless opted in | persona/tone |

## Files to touch
- resources/token-budget.md — add the "Level selection" matrix to §1 (replace the one-line Levels note).
- skills/opt-caveman/SKILL.md — Levels section points to the matrix; keep the 3 definitions.
- skills/core-explore/SKILL.md — one-line hint: bulk results back to orchestrator → `ultra`.
- skills/dev-batch/SKILL.md — one-line hint: item lists / progress data → `ultra`/`full`.
- docs/design-docs/F44/evidence.md

## Not in scope
Changing the on-by-default rule (F43) or the carve-outs; trace logging (user declined). No new hook.

## Risks / unknowns
- Don't conflate caveman level `full` with "full prose" — spell out the distinction.
- Keep it scannable; the matrix is the deliverable, skill hints stay one line.
