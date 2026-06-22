# Evidence: Language dev skills

## What was built
Four language-specific dev skills + one convention, completing the dev tier (component x language):
- skills/dev-js-ts, dev-python, dev-go, dev-rust — each thin: setup/tooling, idioms, layout; links its
  convention; explicitly COMPOSES with a component skill (dev-be/fe/cli/db/batch) rather than duplicating it.
- resources/conventions/rust.md — new (js-ts/python/go conventions already existed).
- CATEGORIES.md dev row updated to list component + language skills.

## Test
F22 verification ran and passed:
```
for s in dev-js-ts dev-python dev-go dev-rust; do test -f skills/$s/SKILL.md; done \
  && test -f resources/conventions/rust.md && grep -q conventions/rust.md skills/dev-rust/SKILL.md && validate -> PASS
```
Re-audit: each language skill links its convention (js-ts->typescript-node, python->python, go->go,
rust->rust); full-catalog dangling-skill-reference scan returns none.

## Review
Self-review: language skills avoid redundancy with component skills + conventions by being the
"how-in-language" layer that composes with the "what" (component) layer — stated in each skill.
All relative links resolve; no new dangling references; CATEGORIES stays accurate. dev-system-design /
dev-design-patterns intentionally excluded (not languages); more languages (java, etc.) are an easy
additive extension. No issues.

## Key decisions made
- Component (dev-be/fe/cli/db/batch) x language (dev-js-ts/python/go/rust) split: orthogonal, composable,
  no duplication. A Go service = dev-be + dev-go.
- Added rust convention because the harness platform itself is Rust and it was the only supported
  language lacking both a skill and a convention.
