# Plan: Vendor test/design/debug experts + wire test/design/bugfix/review

## Behavior to implement
9 test/design/debug experts vendored; test-*, design-api, design-architecture, workflow-bugfix,
check-code-review delegate via the map; lint-expert-map + validate pass.

## Approach
1. Vendor 9 dirs: test-master, playwright-expert, tdd-workflow, webapp-testing, api-designer,
   architecture-designer, code-reviewer, debugging-wizard, debug-diagnose.
2. Update `resources/expert-skills-map.md` — add a "Test / design / debug" table section + fenced
   names (→ 36 total).
3. Wire:
   - test skills → `test-master` (strategy/cases), `playwright-expert` + `webapp-testing` (e2e/UI),
     `tdd-workflow` (red-green). Pointer added to the test-* skills that benefit.
   - `design-api` → `api-designer`; `design-architecture` + `design-detailed` → `architecture-designer`.
   - `workflow-bugfix` → `debugging-wizard` + `debug-diagnose`.
   - `check-code-review` → `code-reviewer`.

## Files to touch
- `.harness/skills-src/skills/{test-master,playwright-expert,tdd-workflow,webapp-testing,api-designer,architecture-designer,code-reviewer,debugging-wizard,debug-diagnose}/**`
- `.harness/skills-src/resources/expert-skills-map.md`
- harness skills: test-e2e, test-unit, test-integration, design-api, design-architecture,
  design-detailed, workflow-bugfix, check-code-review (delegation pointers)
- `docs/design-docs/F42/evidence.md`

## Not in scope
Cloud/DB/AI-ML/security/observability/CI-CD experts (future F43+). No tooling change.

## Risks / unknowns
Frontmatter name+description in first 12 lines (validate). Map table + fenced list in sync.
Verification requires design-api AND workflow-bugfix to reference expert-skills-map.
