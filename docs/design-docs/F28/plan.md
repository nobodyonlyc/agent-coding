# Plan: Enrich test-unit with TDD tracer-bullet
## Behavior to implement
test-unit adopts red-green-refactor tracer-bullet TDD (behavior-through-public-interface, anti-pattern horizontal slicing); passes lint-depth.
## Approach
Rewrite skills/test-unit/SKILL.md to depth bar adopting tdd-workflow (MIT, theNeoAI): One-Liner;
Core Philosophy (test behavior via public interface; anti-pattern = horizontal slicing/bulk-first);
phases Plan -> Tracer bullet -> Incremental loop, each with Gate; Bad/Good example
(implementation-coupled vs behavior test). Keep harness wiring (verify, check-test-strategy).
## Files to touch
- Modify: skills/test-unit/SKILL.md ; This repo: bump submodule + evidence.
## Not in scope
- F29/F30; integration/e2e skills.
## Risks / unknowns
- Keep "Use when:" trigger; test-unit is "always required" per strategy.
