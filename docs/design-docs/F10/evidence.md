# Evidence: opt-caveman

## What was built
skills/opt-caveman/SKILL.md — wraps vendor/caveman; activates compression on inter-agent prompts +
subagent results (auto via caveman-budget hook or proactively for fan-out); levels lite/full/ultra;
hard rule: never compress user-facing output (esp. non-tech) or downgrade a quality gate.

## Test
F10 verification ran and passed:
```
test -f skills/opt-caveman/SKILL.md && grep -qi caveman resources/token-budget.md && validate -> PASS
```
Skill doc -> structural test. No runtime test.

## Review
Self-review: scope matches token-budget.md exactly (inter-agent only, never user-facing unless opted
in, never reasoning). Ties to the F12 caveman-budget hook and vendor/caveman submodule (verified path).
"Quality outranks cost" restated. Non-tech protection explicit. No issues.

## Key decisions made
- opt-caveman is a thin policy wrapper over the upstream caveman submodule, so upstream improvements
  flow in via submodule update without changing this skill.
