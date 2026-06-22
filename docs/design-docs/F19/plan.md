# Plan: Phase 8 Fixbug/QA

## Behavior to implement
QA skill drives a reproduce->fix->re-verify loop until all selected tests pass.

## Approach
check-qa: the loop that runs after code+review, executes the task's selected test set, and on any
failure routes to a minimal fix (reproduce-first) then re-runs until green or capped. Records the
loop outcome to evidence. Links workflow-bugfix, check-test-strategy, step-gate.

## Files to touch
- New: skills/check-qa/SKILL.md
- This repo: bump submodule; docs/design-docs/F19/evidence.md.

## Not in scope
- The individual test skills (F17/18) and review (F08); check-qa orchestrates them.

## Risks / unknowns
- Loop must be capped (runaway protection) and escalate to ask-user if it cannot reach green.
