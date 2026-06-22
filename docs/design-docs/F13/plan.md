# Plan: Phase 2 System Design

## Behavior to implement
System design skills cover architecture, DB schema, API contracts and detailed/component design with design patterns.

## Approach
Four skills: design-architecture (components/boundaries/stack), design-database (schema/ER/migrations),
design-api (contracts/endpoints/error model), design-detailed (component-level design + patterns).
Each persona-branched: dev sees trade-offs + approves; non-tech gets conventional defaults + logged.
Output design docs to files. Link persona-mode, step-gate, token-budget.

## Files to touch
- New: skills/design-architecture, skills/design-database, skills/design-api, skills/design-detailed (SKILL.md each)
- This repo: bump submodule; docs/design-docs/F13/evidence.md.

## Not in scope
- UI design (F14); task split + test-strategy (F15); implementation (F16).

## Risks / unknowns
- Keep each design skill scoped so they compose (architecture -> db/api -> detailed) without overlap.
