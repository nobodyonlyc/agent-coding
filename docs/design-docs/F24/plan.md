# Plan: Bootstrap Stage A as F00 child-tasks

## Behavior to implement
workflow-bootstrap always decomposes Stage A into child-tasks F00-T1 BA, F00-T2 design, F00-T3 UI, F00-T4 plan+skeleton; children run one-at-a-time (WIP=1), parent F00 verified only after all children pass; plan-tasks documents the setup decomposition.

## Approach
Probe confirmed: starting parent F00 then a child violates WIP=1. So:
- Pre-flight: harness add F00 (parent, not_started) + add F00-T1..T4 (--area task, parent: F00).
- Stage A = run each child as a mini-loop: plan -> start -> produce artifact -> review -> verify.
  - F00-T1 BA (plan-ba-analysis + plan-us-backlog -> requirements.md + seed US backlog F01..)
  - F00-T2 design (design-*)
  - F00-T3 UI (design-ui/ux-flow)
  - F00-T4 plan-tasks + plan-skeleton (child-tasks for US + frozen test-strategy + green skeleton)
- Close Stage A: after T1..T4 passing (nothing in_progress), harness start F00 -> write F00 evidence
  (summary + links to child evidence) -> harness verify F00 -> passing. THEN Stage B (per-US).
- Resume mid-setup surfaces the active child (e.g. F00-T2). Supersedes F23's "start F00 + tick boxes".
Update plan-tasks to note it decomposes Stage A setup too (same child-task mechanism as a US).

## Files to touch
- Modify: skills/workflow-bootstrap/SKILL.md (Stage A section), skills/plan-tasks/SKILL.md
- This repo: bump submodule; docs/design-docs/F24/evidence.md.

## Not in scope
- Stage B / workflow-feature (unchanged). Size-based opt-out (user chose: always split).

## Risks / unknowns
- Parent F00 must NOT be in_progress while a child runs (WIP=1) -> start parent only after children pass.
