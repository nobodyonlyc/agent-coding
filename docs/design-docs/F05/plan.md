# Plan: workflow-feature + workflow-bugfix

## Behavior to implement
workflow-feature/bugfix execute a US/bug on an existing harness project through the same gated phase chain (BA delta -> design -> plan -> code -> review -> test -> fix -> ship).

## Approach
Author two SKILL.md:
- workflow-feature: execute one backlog US end-to-end (plan -> start -> code -> review -> test(selected) -> verify -> ship), reusing phase skills; persona + step-gate; solo/team aware.
- workflow-bugfix: reproduce -> locate -> minimal fix -> regression test -> review -> verify; emphasises regression + the failing-test-first loop.
Both link resources and the check-test-strategy selector.

## Files to touch
- New: .harness/skills-src/skills/workflow-feature/SKILL.md, skills/workflow-bugfix/SKILL.md
- This repo: bump submodule pointer; docs/design-docs/F05/evidence.md.

## Not in scope
- Phase leaf skills' internals; the team coordination mechanics (F06).

## Risks / unknowns
- Keep feature vs bugfix distinct: feature = add capability via full chain; bugfix = reproduce-first, regression-focused, smaller design footprint.
