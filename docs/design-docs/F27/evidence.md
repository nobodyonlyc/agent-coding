# Evidence: workflow-bugfix debug-diagnose

## What was built
Rewrote workflow-bugfix to the depth bar adopting debug-diagnose (MIT): One-Liner + Core Philosophy
(loop before theory) + 6 phases each with a Gate (build feedback loop → reproduce exactly → 3-5
ranked falsifiable hypotheses → confirm one → minimal fix → regression+verify), with an inline
hypothesis example. Harness wiring kept (check-test-strategy, check-review-loop, task-state); rules
retained (failing-test-before-fix, regression mandatory, WIP=1).

## Test
F27 verification passed:
```
grep -qi "feedback loop|hypothes" workflow-bugfix && lint-depth workflow-bugfix && validate -> VERIFY-CMD PASS
```
lint-depth workflow-bugfix: PASS. No broken links.

## Review
- [x] description carries a "Use when:" trigger clause (lint-depth requires it) — present.
- [x] every phase ends in a concrete Gate (weak-model checkpoint) — verified all 6.
- [x] methodology attributed to debug-diagnose (MIT) — credited in-skill.

## Key decisions made
- Replaced the thin reproduce-first note with the full 6-phase loop so weaker models follow the same
  deterministic path; kept the existing harness gates rather than the upstream's generic ending.
