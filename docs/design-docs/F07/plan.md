# Plan: Phase 1 BA (plan-ba-analysis + plan-us-backlog)

## Behavior to implement
BA skills elicit requirements and produce a US backlog; behavior branches on user_role (non-tech=requirement-level, dev=exhaustive acceptance/edge/NFR).

## Approach
- plan-ba-analysis: elicit goals/users/scope; persona-branched question depth; output a requirements doc.
- plan-us-backlog: turn requirements into prioritized User Stories with acceptance criteria; seed harness backlog (harness add).
Link persona-mode, step-gate, agent-tool-mapping.

## Files to touch
- New: skills/plan-ba-analysis/SKILL.md, skills/plan-us-backlog/SKILL.md
- This repo: bump submodule; docs/design-docs/F07/evidence.md.

## Not in scope
- System/UI design (F13/F14); task splitting + test-strategy (F15).

## Risks / unknowns
- plan-ba-analysis must grep-contain "persona" (verification) and genuinely branch on user_role.
