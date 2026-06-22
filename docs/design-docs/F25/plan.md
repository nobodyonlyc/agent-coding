# Plan: Review-fix loop

## Behavior to implement
check-review-loop runs an independent (adversarial) reviewer, records findings as a tracked checklist in evidence ## Review, drives a fix->re-review loop (capped+escalate), and a hard review-fix-gate hook blocks verify while any finding stays open.

## Approach
Make review symmetric with check-qa (which loops tests). New pieces:
1. skills/check-review-loop/SKILL.md — orchestrates: spawn an INDEPENDENT reviewer subagent (the
   author does not review own code), record findings as a tracked checklist in evidence ## Review
   (- [ ] open / - [x] fixed / - [x] (accepted: reason)), then loop fix -> re-review until all
   findings resolved, capped (3-5) + escalate via ask-user.
2. hooks/review-fix-gate.sh — HARD gate: on `harness verify <id>`, scan evidence ## Review; if any
   "- [ ]" open finding remains, block (exit 1).
3. Update check-code-review to record findings AS the tracked checklist + hand to check-review-loop.
4. Wire review-fix-gate into config-templates (claude + antigravity).
5. workflow-feature/workflow-bootstrap phase 6 reference check-review-loop.

## Files to touch
- New: skills/check-review-loop/SKILL.md, hooks/review-fix-gate.sh
- Modify: skills/check-code-review/SKILL.md, config-templates/{claude.settings.json,antigravity.hooks.json},
  skills/workflow-feature/SKILL.md, skills/workflow-bootstrap/SKILL.md, CATEGORIES.md (check- row)
- This repo: bump submodule; docs/design-docs/F25/evidence.md.

## Not in scope
- Changing check-qa (test loop stays). Coverage enforcement (separate concern).

## Risks / unknowns
- review-fix-gate must scan ONLY the ## Review section (not task-state) and treat only "- [ ]" as open.
- Independent reviewer = spawn-subagent capability; runtimes lacking it fall back to a fresh-context self-review pass (documented).
