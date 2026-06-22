# Plan: Phase 9 Deploy

## Behavior to implement
Delivery skills handle commit msg, PR, release and deploy; deploy is an always-stop confirmation step.

## Approach
- ship-commit-msg: conventional commit message from the diff (fast tier).
- ship-pr-create: open a PR with summary/test evidence; ties to check-pr-review (team gate).
- ship-release: tag/changelog/version bump (strong tier).
- ship-deploy: deploy to an environment - ALWAYS-STOP confirm before any non-local deploy.
Link autonomy-mode (always-stop list), step-gate.

## Files to touch
- New: skills/ship-commit-msg, skills/ship-pr-create, skills/ship-release, skills/ship-deploy (SKILL.md)
- This repo: bump submodule; docs/design-docs/F09/evidence.md.

## Not in scope
- CI provider specifics; core-* skills (F20); caveman (F10).

## Risks / unknowns
- ship-deploy must encode the always-stop rule clearly (prod/non-local deploy never auto).
