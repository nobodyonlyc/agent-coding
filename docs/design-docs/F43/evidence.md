# Evidence: Caveman as a standing rule across all workflows

## What was built
Made caveman **on by default** across every workflow, in two layers:

**Portable rule (all agents — Claude/Antigravity/Codex):**
- `resources/token-budget.md` §1 rewritten to "Caveman — ON BY DEFAULT in every workflow": a
  standing rule to apply `opt-caveman` to every inter-agent prompt + subagent result, with the
  carve-outs kept (not user-facing output, not reasoning, never where it weakens a gate).
- `skills/opt-caveman/SKILL.md` "When to activate" → on by default; the `caveman-budget` hook is now
  framed as the high-usage *escalation*, not the trigger.
- All 5 workflows carry one consistent explicit line invoking `opt-caveman`:
  - workflow-intake — "Caveman (on by default)… standing rule for all routes".
  - workflow-feature — "…(reviewer/tester fan-out especially)".
  - workflow-bootstrap — "…across Stage A and Stage B".
  - workflow-team — "…including PR-review fan-out".
  - workflow-bugfix — "…caveman on by default" (was an indirect "token-budget as in feature").

**Claude reinforcement (the rule that runs):**
- New `hooks/caveman-activate.sh` (SessionStart): merge-safely records `caveman_mode: "on"` in
  `.harness/context.json` and prints the directive to stderr; exit 0. Verified merge-safe (keeps
  existing keys) and idempotent.
- Wired into config-templates: `claude.settings.json` `SessionStart`, `antigravity.hooks.json`
  `sessionStart`, and documented in `codex.md` (with a note that the rule is portable even without
  hooks).

## How it was verified
Immutable verification command:
```
cd .harness/skills-src && for s in workflow-intake workflow-feature workflow-bootstrap workflow-team \
  workflow-bugfix; do grep -qi opt-caveman skills/$s/SKILL.md || exit 1; done \
  && grep -qiE "on by default" resources/token-budget.md && test -x hooks/caveman-activate.sh \
  && grep -q caveman-activate config-templates/claude.settings.json && bash scripts/validate.sh
```
Result: **EXIT=0**. `validate: PASS` (incl. `bash -n` on the new hook). Both JSON templates parse.
Hook smoke test: starting from `{"user_role":"Developer"}` → `{user_role, caveman_mode:"on"}`,
unchanged on re-run. Workflow relative-link recheck: no broken links.

## Review
- [x] All 5 workflows reference `opt-caveman` explicitly (verification greps each).
- [x] token-budget.md states the on-by-default standing rule; carve-outs preserved (quality hard-rule intact).
- [x] caveman-activate.sh: valid bash, executable, merge-safe, idempotent, exit 0.
- [x] Wired in all 3 config-templates; JSON valid.
- [x] validate.sh PASS; links re-verified.

## Key decisions made
- **Two-layer design**: the authoritative rule lives in the skills (portable to every agent, as
  codex.md's philosophy requires); the SessionStart hook is the Claude-side activation/announcement.
- **Honest limitation (documented in the hook + plan)**: a hook cannot verify the model actually
  compressed a given prompt — it sets `caveman_mode:on` and injects the directive. Enforcement of the
  *behavior* is via the skills' standing rule, not a hard block.
- **Quality carve-outs kept**: "on by default" explicitly excludes user-facing output, reasoning,
  and any judgment-critical prose where compression would weaken a review/test/verify gate.
- Did NOT change the existing `caveman-budget.sh` (Stop) escalation; the two hooks are complementary.
