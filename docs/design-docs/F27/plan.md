# Plan: Enrich workflow-bugfix with debug-diagnose 6-phase

## Behavior to implement
workflow-bugfix adopts feedback-loop-first 6-phase structured debugging (ranked falsifiable hypotheses, gates); passes lint-depth.

## Approach
Rewrite skills/workflow-bugfix/SKILL.md to the depth bar (skill-depth-standard.md) adopting the
debug-diagnose methodology (MIT, theNeoAI): One-Liner; Core Philosophy (build the loop before
theorizing); 6 phases each with a Gate — (1) build feedback loop, (2) reproduce exactly, (3) 3-5
ranked falsifiable hypotheses, (4) bisect/instrument to confirm one, (5) minimal fix, (6) regression
+ verify. Keep harness wiring (check-test-strategy, check-review-loop, task-state). Inline fenced
example satisfies on-demand-depth marker.

## Files to touch
- Modify: skills/workflow-bugfix/SKILL.md
- This repo: bump submodule; docs/design-docs/F27/evidence.md.

## Not in scope
- A separate core-debug skill; other backbone skills (F28-F30).

## Risks / unknowns
- Keep "Use when:" in description for lint-depth triggers; keep failing-test-before-fix rule.
