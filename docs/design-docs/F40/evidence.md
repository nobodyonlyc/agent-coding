# Evidence: Vendor language-pro experts + wire harness language skills

## What was built
Vendored the 11 remaining language experts (MIT, nobodyonlyc/skills @ f6c3127) as first-class
skills with their references/: typescript-pro, javascript-pro, golang-pro, rust-engineer,
java-architect, cpp-pro, csharp-developer, kotlin-specialist, swift-expert, php-pro, sql-pro.
(python-pro landed in F39 → 12 languages total.)

Wiring:
- **dev-js-ts** → delegates to `typescript-pro` (TS) / `javascript-pro` (vanilla JS/Node).
- **dev-go** → delegates to `golang-pro`.
- **dev-rust** → delegates to `rust-engineer`.
- `resources/expert-skills-map.md` table + fenced list updated to all 12; languages without a
  `dev-<lang>` wrapper (Java/C++/C#/Kotlin/Swift/PHP/SQL) are listed with a note to invoke the
  expert directly under a component skill (dev-be/dev-cli/dev-db).

## How it was verified
Immutable verification command:
```
cd .harness/skills-src && for s in typescript-pro javascript-pro golang-pro rust-engineer \
  java-architect cpp-pro csharp-developer kotlin-specialist swift-expert php-pro sql-pro; do \
  test -f skills/$s/SKILL.md || exit 1; done && grep -qi typescript-pro skills/dev-js-ts/SKILL.md \
  && grep -qi golang-pro skills/dev-go/SKILL.md && grep -qi rust-engineer skills/dev-rust/SKILL.md \
  && bash scripts/lint-expert-map.sh && bash scripts/validate.sh
```
Result: **EXIT=0**. `lint-expert-map: PASS (12 experts vendored)`, `validate: PASS`. Relative-link
recheck on the 3 wired skills: no broken links.

## Review
- [x] 11 language experts vendored with references/, name+description in first 12 lines.
- [x] MIT frontmatter preserved on each.
- [x] dev-js-ts/dev-go/dev-rust delegate to their experts without losing harness wiring.
- [x] Map table + fenced list both updated and in sync (lint parses the fenced list → 12).
- [x] validate.sh PASS; links re-verified.

## Key decisions made
- dev-js-ts points to two experts (TS + JS) since it covers both; the map row split makes the
  trigger explicit.
- Wrapper-less languages are vendored + documented rather than given a new thin dev-<lang> skill —
  the expert + a component skill already covers them; avoids needless harness surface.
- Scope held to F40.
