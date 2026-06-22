# Evidence: Review-fix loop

## What was built
Made review symmetric with check-qa (which loops tests):
- skills/check-review-loop/SKILL.md — independent (adversarial) reviewer via spawn-subagent (fresh-context
  fallback documented); findings recorded as a tracked checklist in evidence ## Review; capped fix->re-review
  loop until no "- [ ]" open; escalate via ask-user.
- hooks/review-fix-gate.sh — HARD gate: blocks `harness verify <id>` while the ## Review section has any
  "- [ ]" open finding (scoped to the ## Review section only).
- check-code-review updated to record findings AS the checklist + hand off to check-review-loop.
- Wired review-fix-gate into config-templates (claude PreToolUse + antigravity verify).
- workflow-feature / workflow-bootstrap phase 6 now drive check-review-loop; CATEGORIES updated.

## Test
F25 verification ran and passed:
```
test -f check-review-loop && test -f review-fix-gate.sh && bash -n review-fix-gate.sh \
  && grep -qiE "independent|subagent" check-review-loop && grep -q review-fix-gate claude.settings.json && validate -> PASS
```
Hook behavior tested on a throwaway evidence:
- ## Review with an open "- [ ]" -> REVIEW-FIX GATE blocks (exit 1).
- same finding marked "- [x] … fixed" -> passes (exit 0).
JSON templates valid; all hooks bash -n clean; no broken links in edited files.

## Review
- [x] review-fix-gate must scan only ## Review (not task-state checklists) — verified via awk section
  isolation + throwaway test; only "- [ ]" counts as open. (file: hooks/review-fix-gate.sh)
- [x] independent-reviewer fallback documented for runtimes without spawn-subagent. (check-review-loop)
- [x] No broken relative links introduced (re-audited 4 edited skills). — fixed/clean
- [x] check-qa (tests) left unchanged; the two loops are complementary, not overlapping. (accepted: by design)

## Key decisions made
- Independent reviewer (author != reviewer) addresses the self-review bias flagged earlier; falls back
  to a fresh-context pass where subagents are unavailable so the gate never blocks on a missing tool.
- Gate keys on the literal "- [ ]" inside ## Review only, so it composes with (does not double-count)
  review-gate (placeholder check) and quality-gate (section presence).
