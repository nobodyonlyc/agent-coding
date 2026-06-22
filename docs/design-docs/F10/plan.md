# Plan: opt-caveman + token-budget wiring

## Behavior to implement
opt-caveman skill activates vendored caveman for inter-agent prompts per token-budget policy.

## Approach
skills/opt-caveman/SKILL.md: when to activate caveman (inter-agent prompts, not user-facing),
levels lite/full/ultra, how it ties to vendor/caveman + caveman-budget hook + token-budget resource.
token-budget.md already references caveman (verification grep). Link agent-tool-mapping (tiers).

## Files to touch
- New: skills/opt-caveman/SKILL.md
- This repo: bump submodule; docs/design-docs/F10/evidence.md.

## Not in scope
- Modifying vendor/caveman (upstream submodule); the caveman-budget hook (F12, done).

## Risks / unknowns
- Must keep the rule: never compress user-facing output unless user opts in.
