# Plan: Phase 5 Code

## Behavior to implement
Per-component developer skills implement code following language conventions.

## Approach
Five dev skills (dev-be, dev-fe, dev-cli, dev-db, dev-batch) each describing how to implement that
component type within a child-task, following resources/conventions/. Create resources/conventions/
with language guides (typescript-node, python, go). Each dev skill: read task plan -> implement
minimal slice -> self-check -> hand to review/test. Link conventions, persona, token-budget.

## Files to touch
- New: skills/dev-be, skills/dev-fe, skills/dev-cli, skills/dev-db, skills/dev-batch (SKILL.md)
- New: resources/conventions/{typescript-node,python,go}.md
- This repo: bump submodule; docs/design-docs/F16/evidence.md.

## Not in scope
- Review (F08), test (F17/18). dev skills hand off to them.

## Risks / unknowns
- F16 verification requires resources/conventions/ to exist as a directory -> create it with real guides.
