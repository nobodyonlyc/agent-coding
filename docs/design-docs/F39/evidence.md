# Evidence: Expert-skill bridge infra + vendor python-pro (proof)

## What was built
The bridge that lets thin harness skills delegate craft to vendored expert skills, proved end-to-end
with one expert:

- **Vendored `skills/python-pro/`** (SKILL.md + 5 references: async-patterns, packaging,
  standard-library, testing, type-system) from nobodyonlyc/skills @ `f6c3127`. First-class skill —
  `install.sh` symlinks all of `skills/` into `.claude/skills`, so it is directly invocable. Its
  original `license: MIT` / `author` frontmatter is preserved.
- **`vendor/EXPERT-SKILLS.md`** — provenance manifest: source repo + pinned sha + MIT attribution.
- **`resources/expert-skills-map.md`** — the registry: a human table (harness skill → stack →
  expert) plus a machine-checked fenced `text` list of vendored expert names (the single source the
  lint parses).
- **`scripts/lint-expert-map.sh`** (exec) — parses the fenced list and asserts every name resolves
  to `skills/<name>/SKILL.md`; fails on any miss or an empty list.
- **`scripts/vendor-experts.sh`** (exec) — documents/reproduces vendoring from the pinned sha.
- **Wired `dev-python`** — added a "Delegate craft depth to the expert" pointer to `python-pro` via
  the map; the harness wiring (persona/conventions/handoff/gates) is unchanged.

## How it was verified
Immutable verification command:
```
cd .harness/skills-src && test -f skills/python-pro/SKILL.md && test -f resources/expert-skills-map.md \
  && test -x scripts/lint-expert-map.sh && grep -qi python-pro skills/dev-python/SKILL.md \
  && bash scripts/lint-expert-map.sh && bash scripts/validate.sh
```
Result: **EXIT=0**.
```
lint-expert-map: PASS (1 experts vendored)
== validate: PASS ==
```

## Review
- [x] python-pro vendored with references/, name+description in first 12 lines (validate-safe).
- [x] MIT license/author frontmatter preserved; provenance recorded in vendor/EXPERT-SKILLS.md.
- [x] Registry has both a human table and a machine-checked fenced list (single source for lint).
- [x] lint-expert-map.sh parses the fenced block and verifies each expert resolves; non-empty guard.
- [x] dev-python delegates to python-pro without losing harness wiring.
- [x] validate.sh PASS (vendored skill does not break structure checks).

## Key decisions made
- Experts vendored into `skills/` (first-class, auto-symlinked) rather than `vendor/`, so the agent
  can invoke them directly — `vendor/` is reserved for non-skill payloads (caveman submodule).
- The fenced `text` list, not the table, is the lint's source of truth — deterministic to parse.
- No deep-bar `lint-depth` enforced on experts (they have their own richer structure).
- Scope held to F39; the other 35 experts are F40–F42.
