# Evidence: Phase 9 Deploy

## What was built
- ship-commit-msg (fast) — Conventional Commit from the diff.
- ship-pr-create — PR with test evidence; entry to the check-pr-review team gate.
- ship-release (strong) — semver bump + changelog + tag; only verified work; outward push confirmed.
- ship-deploy — deploy with ALWAYS-STOP confirmation for any non-local env; pre-checks, confirm,
  migrate, post-verify, rollback.

## Test
F09 verification ran and passed:
```
for s in ship-commit-msg ship-pr-create ship-release ship-deploy; do test -f skills/$s/SKILL.md; done && validate -> PASS
```
Skill docs -> structural test. No runtime test.

## Review
Self-review: ship-deploy encodes the always-stop rule explicitly (overrides gated/auto, prod never
auto), matching autonomy-mode. Model tiers assigned per CATEGORIES (commit=fast, release=strong).
PR creation ties to the team review gate; release only ships passing+evidenced work. No issues.

## Key decisions made
- Deploy is the canonical always-stop demonstration: confirmation required every time, even unattended.
- Commit-msg is fast-tier, release is strong-tier — cost optimization that does not touch a quality gate.
