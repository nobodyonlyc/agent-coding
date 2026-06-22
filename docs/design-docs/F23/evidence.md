# Evidence: Resumable bootstrap (F00 tracking feature)

## What was built
Reworked skills/workflow-bootstrap/SKILL.md to close the resumability gap in the setup phases:
- Pre-flight now creates + starts a bootstrap tracking feature `F00` (artifact-existence + `./init.sh`
  smoke verification) and expands `.harness/tasks/F00.md` with one box per Stage-A phase.
- Split the flat 9-phase chain into **Stage A** (①BA ②design ③UI ④plan-tasks — tracked under F00,
  runs once; tick + commit per phase) and **Stage B** (⑤–⑨ per-US via workflow-feature, repeated).
- "Close Stage A" step: `harness verify F00` -> passing BEFORE any US starts (keeps WIP=1).
- Added a Resumability section: after interrupt, `harness resume` shows F00 (mid-setup) or the current
  US (mid-build) + task-state next step — no progress lives only in chat.

## Test
F23 verification ran and passed:
```
grep -qi "harness add F00" workflow-bootstrap && grep -qi resum workflow-bootstrap \
  && grep -qi "per-US" workflow-bootstrap && validate -> VERIFY-CMD PASS
```
Relative-link recheck on the edited file: no broken links. Skill doc -> structural test; no runtime.

## Review
Self-review: WIP=1 preserved (F00 passes before F01 starts; `harness add` of US during F00 is allowed,
only `start` is gated). F00 verification is stack-generic (artifact existence + init.sh smoke). The
two-stage split also resolves the earlier "flat 9-phase mislabel" finding. Persona section updated to
say "Stage A" instead of "phases ①–④". task-state checkpoint already required per phase (F21) now has
an anchor (F00) during setup. No broken links, no scope creep. No issues.

## Key decisions made
- PA1 (F00 tracking feature) over PA2 (early backlog seed): design/UI are cross-cutting and do not fit
  a single US; a dedicated setup feature is the natural anchor and reuses resume/verify/task-state as-is.
- F00 uses priority 0 + area infra so it sorts ahead of the US backlog and reads as setup, not a US.
