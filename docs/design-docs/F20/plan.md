# Plan: Core skills

## Behavior to implement
Everyday single-agent skills for exploring, explaining, quick fixes and file ops.

## Approach
Four core skills:
- core-explore: read-only search/locate across the codebase (fast, returns conclusions).
- core-explain: explain code/architecture to a user (persona-aware language).
- core-fix: small, scoped fix without the full feature pipeline (still tested + reviewed lightly).
- core-file-ops: mechanical file create/move/rename/delete (fast tier).
Link persona-mode, token-budget, agent-tool-mapping.

## Files to touch
- New: skills/core-explore, skills/core-explain, skills/core-fix, skills/core-file-ops (SKILL.md)
- This repo: bump submodule; docs/design-docs/F20/evidence.md.

## Not in scope
- Full workflow pipeline (those are workflow-*); these are quick single-agent helpers.

## Risks / unknowns
- core-fix must not become a backdoor around review/test for real features -> scope it to trivial changes.
