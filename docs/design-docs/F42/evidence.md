# Evidence: Vendor test/design/debug experts + wire test/design/bugfix/review

## What was built
Vendored 9 test/design/debug experts (MIT, nobodyonlyc/skills @ f6c3127) with references/:
test-master, playwright-expert, tdd-workflow, webapp-testing, api-designer, architecture-designer,
code-reviewer, debugging-wizard, debug-diagnose. This completes the core scope → **36 experts**.

Wiring (delegation pointers via the map):
- **test-unit** → `test-master` (architecture/mocking/coverage), `tdd-workflow` (red-green).
- **test-e2e** → `playwright-expert`, `webapp-testing` (browser/UI).
- **design-api** → `api-designer`.
- **design-architecture** (and design-detailed) → `architecture-designer`.
- **check-code-review** → `code-reviewer`.
- **workflow-bugfix** → `debugging-wizard` + `debug-diagnose` (the prior prose credit to
  debug-diagnose is now a live link to the vendored skill).
- `resources/expert-skills-map.md` gained a "Test / design / debug" table + 9 fenced names.

## How it was verified
Immutable verification command:
```
cd .harness/skills-src && for s in test-master playwright-expert tdd-workflow webapp-testing \
  api-designer architecture-designer code-reviewer debugging-wizard debug-diagnose; do \
  test -f skills/$s/SKILL.md || exit 1; done && grep -qi expert-skills-map skills/design-api/SKILL.md \
  && grep -qi expert-skills-map skills/workflow-bugfix/SKILL.md && bash scripts/lint-expert-map.sh \
  && bash scripts/validate.sh
```
Result: **EXIT=0**. `lint-expert-map: PASS (36 experts vendored)`, `validate: PASS`. Relative-link
recheck on the 6 wired skills: no broken links.

## Review
- [x] 9 experts vendored with references/, name+description in first 12 lines; no dir-name collisions
      with existing harness skills (code-reviewer ≠ check-code-review, api-designer ≠ design-api, etc.).
- [x] MIT frontmatter preserved.
- [x] test-unit/test-e2e/design-api/design-architecture/check-code-review/workflow-bugfix delegate
      via the map without losing their gates.
- [x] Map table + fenced list in sync (lint = 36).
- [x] validate.sh PASS; links re-verified.

## Key decisions made
- workflow-bugfix's old "adapted from debug-diagnose" credit became a real delegation link now that
  the skill is vendored.
- Completes the core dev/test/design rollout (F39–F42, 36 experts). Cloud/DB/AI-ML/security/
  observability/CI-CD remain available for future features using the same bridge (no infra change).
