# Evidence: Bootstrap Stage A as F00 child-tasks

## What was built
Reworked workflow-bootstrap Stage A to always decompose into child-tasks (probe-driven, WIP-safe):
- Pre-flight seeds parent F00 + F00-T1 (BA) / F00-T2 (design) / F00-T3 (UI) / F00-T4 (plan+skeleton)
  via `--area task` + `parent: F00`; parent is NOT started yet.
- Stage A runs the children one at a time (plan->start->artifact->check-code-review->verify), step-gated.
- Close Stage A: after all children pass, start F00 -> write F00 evidence -> verify F00 -> passing; THEN Stage B.
- Resumability note updated: mid-setup the active F00-Tn child is in_progress (parent stays not-started).
- plan-tasks documents that the same child-task mechanism decomposes Stage A (setup children use
  artifact-existence verifications, not the test matrix).

## Test
F24 verification ran and passed:
```
grep -q "F00-T" workflow-bootstrap && grep -qi child-task workflow-bootstrap \
  && grep -qiE "stage a|setup" plan-tasks && validate -> VERIFY-CMD PASS
```
Behavior probed on the live CLI before writing: starting parent F00 then a child returns
"WIP Limit Error" -> confirmed the parent must be started last. Relative-link recheck on both edited
files: no broken links. Skill docs -> structural test; no runtime.

## Review
Self-review: design is WIP-1-correct by construction (parent started only after children pass, proven
by the probe). Each setup phase now yields its own ## Review evidence (the main quality win the split
buys). Finer resume granularity (active child vs whole F00). Supersedes F23's "start F00 + tick boxes"
cleanly — F23's resumability goal is preserved, just anchored on the child rather than the parent.
No broken links, no scope creep, WIP=1 honored. No issues.

## Key decisions made
- Always split (user choice) — no size-based opt-out; small projects pay 4 mini-loops but get
  per-phase review evidence + recovery.
- Parent F00 started LAST (after children pass) to satisfy WIP=1 — verified against the real CLI.
- Setup children verify by artifact existence (docs exist / init.sh smoke), since BA/design/UI have no
  runtime test surface; the real check remains human approval at the step-gate.
