# Plan: Caveman as a standing rule across all workflows

## Behavior to implement
Caveman is ON by default for inter-agent prompts + subagent results in every workflow
(intake/feature/bootstrap/team/bugfix all invoke opt-caveman explicitly); token-budget states the
on-by-default rule; a SessionStart caveman-activate hook records caveman_mode=on and injects the
directive, wired into the agent config-templates; quality carve-outs preserved; validate passes.

## Approach
Two layers — the portable rule lives in the skills (works for Claude/Antigravity/Codex), the hook is
the Claude reinforcement.
1. **resources/token-budget.md** — rewrite the caveman section to "ON BY DEFAULT in every workflow"
   (standing rule), keeping the 3 carve-outs: not user-facing output, not reasoning/thinking, and
   never where compression would weaken a review/test/verify gate.
2. **opt-caveman/SKILL.md** — "When to activate" updated: on by default across workflows for
   inter-agent traffic; the hook escalation becomes the *high-usage* reminder, not the trigger.
3. **All 5 workflows** — one consistent explicit line naming `opt-caveman`, applied at every
   subagent fan-out (intake/feature/bootstrap/team/bugfix). Each file must grep `opt-caveman`.
4. **hooks/caveman-activate.sh** (new, SessionStart) — merge `caveman_mode: "on"` into
   `.harness/context.json` (python3, safe-merge) and print the standing directive to stderr; exit 0.
5. **Wire** caveman-activate into config-templates: claude.settings.json (`SessionStart`),
   antigravity.hooks.json (`sessionStart`), and a note in codex.md.

## Files to touch
- resources/token-budget.md; skills/opt-caveman/SKILL.md
- skills/{workflow-intake,workflow-feature,workflow-bootstrap,workflow-team,workflow-bugfix}/SKILL.md
- hooks/caveman-activate.sh (new, executable)
- config-templates/{claude.settings.json,antigravity.hooks.json,codex.md}
- docs/design-docs/F43/evidence.md

## Not in scope
- Forcing model cognition: a hook cannot verify the model actually compressed a prompt; it injects a
  standing directive + sets a flag. This is documented, not hidden.
- Changing the existing caveman-budget.sh (Stop) high-usage escalation — kept as-is.

## Risks / unknowns
- New hook must pass `bash -n` (validate.sh checks all hooks). context.json write must be merge-safe
  (don't clobber other keys).
- Keep the quality hard-rule intact; "on by default" must not read as "compress everything incl.
  judgment prose".
