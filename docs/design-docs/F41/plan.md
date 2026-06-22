# Plan: Vendor web-framework experts + wire dev-fe/dev-be

## Behavior to implement
15 web framework experts vendored; dev-fe and dev-be point to the expert map per stack;
lint-expert-map + validate pass.

## Approach
1. Vendor 15 dirs: react-expert, react-native-expert, angular-architect, vue-expert, vue-expert-js,
   nextjs-developer, django-expert, fastapi-expert, spring-boot-engineer, rails-expert,
   laravel-specialist, nestjs-expert, dotnet-core-expert, flutter-expert, frontend-design.
2. Update `resources/expert-skills-map.md` — add a "Web frameworks" table section + fenced names,
   split by frontend (dev-fe) vs backend (dev-be).
3. Wire `dev-fe` and `dev-be` with a "Delegate to the framework expert (see expert-skills-map)"
   pointer — both must mention `expert-skills-map` (verification greps for it).

## Files to touch
- `.harness/skills-src/skills/{react-expert,react-native-expert,angular-architect,vue-expert,vue-expert-js,nextjs-developer,django-expert,fastapi-expert,spring-boot-engineer,rails-expert,laravel-specialist,nestjs-expert,dotnet-core-expert,flutter-expert,frontend-design}/**`
- `.harness/skills-src/resources/expert-skills-map.md`
- `.harness/skills-src/skills/{dev-fe,dev-be}/SKILL.md`
- `docs/design-docs/F41/evidence.md`

## Not in scope
Test/design/debug (F42). No tooling change.

## Risks / unknowns
Frontmatter name+description in first 12 lines per vendored skill (validate). Map table + fenced
list in sync.
