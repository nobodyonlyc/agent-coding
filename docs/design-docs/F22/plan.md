# Plan: Language dev skills

## Behavior to implement
Language-specific dev skills exist for js-ts/python/go/rust, each linking its convention and composing with the component dev-* skills; rust convention added.

## Approach
Add 4 language dev skills (dev-js-ts, dev-python, dev-go, dev-rust). Each is THIN: language setup,
idioms, tooling/test-runner, project layout; links its resources/conventions/<lang>.md; states it
COMPOSES with a component skill (dev-be/fe/cli/db/batch) rather than duplicating it. Add the missing
rust convention. Update CATEGORIES.md dev row to list language skills.

## Files to touch
- New: skills/dev-{js-ts,python,go,rust}/SKILL.md, resources/conventions/rust.md
- Modify: CATEGORIES.md (dev row)
- This repo: bump submodule; docs/design-docs/F22/evidence.md.

## Not in scope
- dev-system-design / dev-design-patterns (not languages); more languages (java, etc.) — easy to add later.

## Risks / unknowns
- Avoid redundancy with component dev skills + conventions: language skill = HOW-in-language, composes with component skill (WHAT).
