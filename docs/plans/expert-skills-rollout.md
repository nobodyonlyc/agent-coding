# Plan: Vendor per-language/framework expert skills and bridge them to the harness

> Handoff plan. The thin `dev-*` / `test-*` / `design-*` skills only carry the *how-in-this-harness*
> layer; they lack deep per-language/framework craft. We vendor a curated set of MIT-licensed expert
> skills from **nobodyonlyc/skills** and have the harness skills **delegate** to them.

## Decisions (locked with the user 2026-06-22)
- **Mechanism: vendor a pinned copy.** Copy the selected `skills/<name>/` (SKILL.md + references/)
  into our `skills/` tree as first-class, invocable skills — `install.sh` already symlinks all of
  `skills/` into `.claude/skills`, so vendored experts become directly usable. Pinned to a commit;
  per-file MIT `license:`/`author:` frontmatter preserved; provenance recorded in a manifest.
- **Scope: core dev/test/design first** (36 skills). Cloud / DB / AI-ML / security / observability /
  CI-CD from the user's table are deferred to later features.
- **Source pin:** `nobodyonlyc/skills` @ `f6c3127a9b90cf17eaa185d61ad5f1496a440891` (branch master).

## Composition model (the bridge)
Harness skills stay the **orchestration spine** (persona, step-gate, conventions, evidence, handoff,
gates). The expert supplies **craft depth**. Wiring lives in `resources/expert-skills-map.md`:
a human table + a machine-checked fenced list of vendored expert names. `dev-*`/`test-*`/`design-*`
gain a short "Delegate to the matching expert" pointer into the map. `scripts/lint-expert-map.sh`
asserts every name in the map's fenced list resolves to `skills/<name>/SKILL.md`.

## Core skill set (36)
- **Languages (12):** python-pro, typescript-pro, javascript-pro, golang-pro, rust-engineer,
  java-architect, cpp-pro, csharp-developer, kotlin-specialist, swift-expert, php-pro, sql-pro
- **Web frameworks (15):** react-expert, react-native-expert, angular-architect, vue-expert,
  vue-expert-js, nextjs-developer, django-expert, fastapi-expert, spring-boot-engineer, rails-expert,
  laravel-specialist, nestjs-expert, dotnet-core-expert, flutter-expert, frontend-design
- **Test/design/debug (9):** test-master, playwright-expert, tdd-workflow, webapp-testing,
  api-designer, architecture-designer, code-reviewer, debugging-wizard, debug-diagnose

## Feature breakdown (backlog F39–F42)
| Feat | Scope | Wires into |
|---|---|---|
| **F39** | Bridge infra: `expert-skills-map.md` + `lint-expert-map.sh` + provenance manifest + attribution; vendor **python-pro** as proof | dev-python |
| **F40** | Vendor remaining 11 language pros | dev-js-ts (ts+js), dev-go, dev-rust; map lists all 12 |
| **F41** | Vendor 15 web framework experts | dev-fe, dev-be (consult the map per stack) |
| **F42** | Vendor 9 test/design/debug experts | test-*, design-api, design-architecture/detailed, workflow-bugfix, check-code-review |

Each feature verification = vendored dirs exist + the named harness skills reference the map/expert
+ `lint-expert-map.sh` passes + `validate.sh` passes.

## Re-vendor recipe
`scripts/vendor-experts.sh` documents the pinned source + sha and how the dirs were copied
(GitHub tarball at the pinned sha → copy `skills/<name>/`). Verifications check the vendored files
exist in-tree, not that the fetch re-runs (no network dependency at verify time).

## Notes / cautions
- Do not force the deep-bar `lint-depth.sh` on vendored experts — they have their own structure and
  already exceed it; lint-depth is only invoked by the harness skills' own verifications.
- Keep WIP=1; one feature in_progress at a time.
- Later expansion (cloud/db/ai-ml/security/observability/ci-cd) = new features F43+ using the same
  bridge; no infra change needed.
