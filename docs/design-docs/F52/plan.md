# Plan: M1 role-resolver — design-derived subagent role spec

## Behavior to implement
`scripts/role-resolver.sh --phase <p> [--language/--framework/--component/--stack] [--format json|brief]`
emits a JSON **role spec** for the subagent a given lifecycle phase must spawn. The role's expertise
is DERIVED FROM THE DESIGN by wrapping `experts-resolver.sh` (which reads the Stack block), so a Go
backend review phase yields `{title:"Go Backend Tech Lead", archetype:"techlead",
expertise:["dev-be","dev-go","golang-pro"], based_on:"...#stack"}`. `resources/phase-roles.md`
documents the phase→archetype mapping (human doc; the script is the source of truth).

## Approach
- `scripts/role-resolver.sh`: thin bash arg-parse + a python3 block (repo style). It calls
  `experts-resolver.sh --format table`, parses `role<TAB>name` lines into the expertise chain, maps
  phase→(archetype, mandate, base_skill) via an embedded table, derives a human title from
  language+component+archetype, and prints the spec as JSON (or a one-line `brief`).
- **Non-blocking degrade:** if the stack is unresolved (no Stack block / unknown language →
  experts-resolver exits non-zero), still emit a valid spec with `expertise: []` and `based_on:
  null` plus a note. Rationale: agent-tool-mapping says a missing capability uses a fallback, never
  blocks — a generic reviewer beats no reviewer.
- `resources/phase-roles.md`: the phase→archetype/mandate/base-skill matrix, marked as documenting
  the resolver (single source of truth = the script).
- `scripts/test-role-resolver.sh`: frozen verification, modeled on `test-experts-resolver.sh`
  (`cd` to skills-src root). Asserts: go/be review → title + archetype + expertise; security phase →
  security-reviewer; design phase → architect; unknown phase → exit 2; degraded (no stack) → valid
  JSON, expertise empty, exit 0; output parses as JSON.

## Files to touch
- `scripts/role-resolver.sh` — NEW (executable).
- `resources/phase-roles.md` — NEW.
- `scripts/test-role-resolver.sh` — NEW (the F52 verification).

## Not in scope
- The CLI provenance commands (H-M2, done) and the enforcement gate (F53).
- Wiring the resolver into skills/workflows (F54).
- Generating phase-roles.md from the script automatically (kept as a documented manual mirror;
  could add a lint later like lint-expert-map.sh).

## Risks / unknowns
- `experts-resolver` requires a `--component` or framework to avoid defaulting to dev-be; the role
  spec records whatever it resolves (with the resolver's own note). Acceptable — the design's Stack
  block usually carries the framework.
- Title quality for non-language-wrapper stacks (e.g. Java → no dev-java): language_h falls back to
  empty, title becomes "Backend Tech Lead" (still valid). Documented.
