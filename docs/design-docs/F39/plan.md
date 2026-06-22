# Plan: Expert-skill bridge infra + vendor python-pro (proof)

## Behavior to implement
resources/expert-skills-map.md registry + scripts/lint-expert-map.sh + provenance manifest +
attribution exist; python-pro vendored as a first-class skill and dev-python delegates to it;
lint-expert-map + validate pass.

## Approach
1. **Vendor python-pro** — copy `skills/python-pro/` (SKILL.md + references/) from the pinned
   tarball (nobodyonlyc/skills @ f6c3127) into `.harness/skills-src/skills/python-pro/`.
2. **Provenance manifest** — `vendor/EXPERT-SKILLS.md`: source repo + sha + per-skill author/license
   (MIT). Preserve each skill's own `license:`/`author:` frontmatter.
3. **Registry** — `resources/expert-skills-map.md`: a human table (harness skill → stack → expert)
   plus a machine-checked fenced ```text list of vendored expert names (the single source the lint
   parses).
4. **Lint** — `scripts/lint-expert-map.sh`: every name in the fenced list resolves to
   `skills/<name>/SKILL.md`; non-empty; exit 1 on any miss.
5. **Wire dev-python** — add a short "Delegate craft to the matching expert (see expert-skills-map):
   `python-pro`" pointer; keep the existing how-in-harness content.

## Files to touch
- `.harness/skills-src/skills/python-pro/**` (vendored, new)
- `.harness/skills-src/vendor/EXPERT-SKILLS.md` (new)
- `.harness/skills-src/resources/expert-skills-map.md` (new)
- `.harness/skills-src/scripts/lint-expert-map.sh` (new, executable)
- `.harness/skills-src/skills/dev-python/SKILL.md` (delegation pointer)
- `docs/design-docs/F39/evidence.md`

## Not in scope
F40–F42 (the other 35 experts); changing validate.sh/install.sh; deep-bar lint on experts.

## Risks / unknowns
- Vendored expert frontmatter must keep `name:`+`description:` in the first 12 lines (validate.sh).
  python-pro does. License/metadata lines are preserved.
- Map must stay the single source for the lint; table + fenced list must agree.
