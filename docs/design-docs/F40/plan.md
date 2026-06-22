# Plan: Vendor language-pro experts + wire harness language skills

## Behavior to implement
11 remaining language experts vendored; dev-js-ts/dev-go/dev-rust delegate to their experts; all 12
languages listed in the map; lint-expert-map + validate pass.

## Approach
1. Vendor 11 dirs from the pinned tarball: typescript-pro, javascript-pro, golang-pro,
   rust-engineer, java-architect, cpp-pro, csharp-developer, kotlin-specialist, swift-expert,
   php-pro, sql-pro.
2. Update `resources/expert-skills-map.md` — add table rows + the fenced-list names.
3. Wire the harness language skills that have a wrapper:
   - `dev-js-ts` → `typescript-pro` + `javascript-pro`
   - `dev-go` → `golang-pro`
   - `dev-rust` → `rust-engineer`
   Languages without a harness wrapper (java/cpp/csharp/kotlin/swift/php/sql) are vendored + listed;
   the map notes "invoke directly under a component skill (dev-be/dev-cli/...)".

## Files to touch
- `.harness/skills-src/skills/{typescript-pro,javascript-pro,golang-pro,rust-engineer,java-architect,cpp-pro,csharp-developer,kotlin-specialist,swift-expert,php-pro,sql-pro}/**` (vendored)
- `.harness/skills-src/resources/expert-skills-map.md`
- `.harness/skills-src/skills/{dev-js-ts,dev-go,dev-rust}/SKILL.md`
- `docs/design-docs/F40/evidence.md`

## Not in scope
Web frameworks (F41), test/design/debug (F42). No tooling change.

## Risks / unknowns
Each vendored skill must keep name+description in the first 12 lines (validate). Keep map table and
fenced list in sync.
