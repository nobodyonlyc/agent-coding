# Evidence: Vendor web-framework experts + wire dev-fe/dev-be

## What was built
Vendored 15 web framework experts (MIT, nobodyonlyc/skills @ f6c3127) as first-class skills with
their references/: react-expert, react-native-expert, angular-architect, vue-expert, vue-expert-js,
nextjs-developer, django-expert, fastapi-expert, spring-boot-engineer, rails-expert,
laravel-specialist, nestjs-expert, dotnet-core-expert, flutter-expert, frontend-design.

Wiring:
- **dev-fe** → delegates to the frontend framework expert per the map (React/Vue/Angular/Next.js,
  React Native/Flutter for mobile, frontend-design for polish).
- **dev-be** → delegates to the backend framework expert per the map (FastAPI/Django/Spring/NestJS/
  Rails/Laravel/ASP.NET/Next.js API).
- `resources/expert-skills-map.md` gained a "Web frameworks" table (frontend vs backend rows) and
  the 15 names were added to the machine-checked fenced list → **27 experts** total.

## How it was verified
Immutable verification command:
```
cd .harness/skills-src && for s in react-expert react-native-expert angular-architect vue-expert \
  vue-expert-js nextjs-developer django-expert fastapi-expert spring-boot-engineer rails-expert \
  laravel-specialist nestjs-expert dotnet-core-expert flutter-expert frontend-design; do \
  test -f skills/$s/SKILL.md || exit 1; done && grep -qi expert-skills-map skills/dev-fe/SKILL.md \
  && grep -qi expert-skills-map skills/dev-be/SKILL.md && bash scripts/lint-expert-map.sh \
  && bash scripts/validate.sh
```
Result: **EXIT=0**. `lint-expert-map: PASS (27 experts vendored)`, `validate: PASS`. Relative-link
recheck on dev-fe/dev-be: no broken links.

## Review
- [x] 15 framework experts vendored with references/, name+description in first 12 lines.
- [x] MIT frontmatter preserved.
- [x] dev-fe/dev-be both reference expert-skills-map (the verification greps for it) without losing
      states-coverage / contract / gate wiring.
- [x] Map table + fenced list updated and in sync (lint = 27).
- [x] validate.sh PASS; links re-verified.

## Key decisions made
- The fenced list was extended to all 27 vendored names so the lint actually guards the frameworks
  (initially only the table was updated — caught during verification and fixed).
- dev-fe vs dev-be delegation is split in the map by frontend/backend rows; Next.js appears under
  both (full-stack).
- Scope held to F41.
