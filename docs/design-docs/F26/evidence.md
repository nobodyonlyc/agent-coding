# Evidence: Skill depth standard + lint-depth + enriched review

## What was built
- resources/skill-depth-standard.md — the deep-skill bar (Use-when triggers, One-Liner, phases+Gates,
  references/ or example) + full template + rules; explains why thin skills break weak models.
- scripts/lint-depth.sh <skill> — enforces the 4 core markers; exit 1 on miss, lists what's missing.
- skills/check-code-review rebuilt to the bar: One-Liner, Core Philosophy, phases with Gates, Bad/Good,
  Reference Guide table + references/{review-checklist,common-issues,report-template}.md.

## Test
F26 verification ran and passed:
```
test -f skill-depth-standard.md && test -x lint-depth.sh && test -d check-code-review/references \
  && lint-depth check-code-review && validate -> VERIFY-CMD PASS
```
Discrimination proven: lint-depth PASS on enriched check-code-review (exit 0); FAIL on thin
core-file-ops (exit 1, lists 4 missing markers). No broken links after fixing the forward ref.

## Review
- [x] forward link to check-security-review (not built until F29) would be a broken link — fixed to a
  plain mention; re-audited check-code-review links, none broken.
- [x] lint-depth kept opt-in (run per-skill via verifications), so the existing thin skills are not
  broken en masse — confirmed validate still passes across all 45 skills. (accepted: opt-in by design)
- [x] lint-depth lenient enough (4 markers) to avoid false-fail, strict enough to catch a thin skill —
  verified on both a deep and a thin sample.

## Key decisions made
- Standard is opt-in per skill (enforced by each skill's harness verification calling lint-depth),
  not a global validate rule — lets backbone skills be deep while mechanical skills stay light.
- check-code-review is the canonical example; F27-F30 follow the same shape.
