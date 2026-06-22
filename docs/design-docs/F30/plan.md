# Plan: Enrich BA (to-prd) + architecture (trade-off/ADR)
## Behavior to implement
plan-ba-analysis emits a PRD-style contract; design-architecture emits a trade-off matrix + ADR; both deep bar + pass lint-depth.
## Approach
Rewrite both to depth bar with explicit OUTPUT CONTRACTS (the main weak-model win): plan-ba-analysis
gets a PRD template (problem/users/stories/acceptance/out-of-scope/risks); design-architecture gets a
trade-off matrix + ADR (Architecture Decision Record) template. One-Liner + phases+Gates + Use-when triggers.
## Files to touch
- Modify: skills/plan-ba-analysis/SKILL.md, skills/design-architecture/SKILL.md ; bump submodule + evidence.
## Not in scope
- Other design/plan skills; registry persona skills.
## Risks / unknowns
- Keep persona branching (non-tech vs dev) intact in BA.
