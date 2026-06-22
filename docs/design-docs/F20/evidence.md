# Evidence: Core skills

## What was built
Four everyday single-agent skills:
- core-explore (read-only locate, returns conclusions not dumps; can fan out subagents)
- core-explain (persona-aware explanation with file:line)
- core-fix (trivial scoped fix; explicitly NOT a backdoor around review/test — escalates to workflows)
- core-file-ops (mechanical create/move/rename/delete; look-before-delete; always-stop out-of-scope)

## Test
F20 verification ran and passed:
```
for s in core-explore core-explain core-fix core-file-ops; do test -f skills/$s/SKILL.md; done && validate -> PASS
```
Skill docs -> structural test. No runtime test.

## Review
Self-review: core-fix has an explicit guardrail (trivial only; escalate to workflow-feature/bugfix for
anything with design/behavior/multi-component impact) so it cannot bypass the quality pipeline.
core-file-ops restates look-before-delete + always-stop-out-of-scope, matching the operating rules.
core-explore is read-only and token-budget-aware. No issues.

## Key decisions made
- core-fix is deliberately fenced to trivial changes so the everyday-helper tier never becomes a way
  to ship untested behavior changes.
