# Plan: Core resources: mapping, autonomy, persona, token-budget, step-gate

## Behavior to implement
resources/ has agent-tool-mapping, autonomy-mode, persona-mode (dev vs non-tech), token-budget (caveman+compaction), step-gate; validator passes.

## Approach
Author the 5 shared convention docs that every later skill links to. These are the behavioral
contract for the whole catalog, so they must be concrete and testable:

1. `resources/agent-tool-mapping.md` — map canonical capabilities (`ask-user`, `spawn-subagents`,
   `generate-image`) and model-tiers (`fast`/`strong`) to each agent (Claude Code / Codex / Antigravity).
2. `resources/autonomy-mode.md` — `gated` (default) vs `auto`; the always-stop list that overrides
   both; where the mode is stored (task-state `Mode:`).
3. `resources/persona-mode.md` — **the dev vs non-tech contract**: how `user_role`
   (Developer / Non-Technical) changes question depth, language, what gets surfaced vs auto-decided,
   and stop cadence. This is the core differentiator the user asked for.
4. `resources/token-budget.md` — caveman policy (compress inter-agent prompts, never user-facing
   output unless opted in), artifact compaction (write long outputs to files, pass summaries),
   context threshold, model-tier reuse. Links `vendor/caveman`.
5. `resources/step-gate.md` — the "confirm before next step" contract: after each phase, ask-user
   with click-select options (run next / run all / revise / stop); in `auto` it becomes a logged decision.

Then run `validate.sh` and the F02 verification.

## Files to touch
- New: `.harness/skills-src/resources/{agent-tool-mapping,autonomy-mode,persona-mode,token-budget,step-gate}.md`
- `.harness/skills-src/resources/.gitkeep` may be removed (dir now has real files).
- This repo: bump `.harness/skills-src` gitlink; `docs/design-docs/F02/evidence.md`.

## Not in scope
- Conventions per language (`resources/conventions/*`) — those ship with F16 (code phase).
- The hook scripts that enforce these contracts — F12.
- Any skill SKILL.md that consumes these resources — F03 onward.

## Risks / unknowns
- persona-mode and step-gate must stay consistent with autonomy-mode (auto vs gated) — cross-link
  them so a skill author cannot read one without the others.
- Keep each doc concise (skills include them by reference); over-long resources inflate context,
  which contradicts token-budget. Target < ~120 lines each.
