# Plan: Declarative skill map via frontmatter + generated expert-skills-map

## Behavior to implement
Each expert/component/wrapper skill declares structured frontmatter (layer, language/framework,
delegates_to, tier) as the SINGLE source of truth. `expert-skills-map.md` (table + fenced block) is
GENERATED from that frontmatter, not hand-maintained; lint fails if the committed map drifts from
frontmatter, eliminating the duplicated source across expert-skills-map.md, stack-defaults.md and
inline dev-* mentions. `tier` feeds F51 (per-host implicit policy); `delegates`/`layer`/`language`
feeds F47 (resolver).

## Approach
1. **Frontmatter schema (the contract).** Add a `metadata:` block to the harness skills we OWN that
   carry map rows (the `dev-*` wrappers/components, plus the `design-*`/`test-*`/`check-*` rows). Do
   NOT require edits to vendored experts beyond what they already have (golang-pro etc. keep their
   `metadata.domain`). Fields on a harness skill:
   - `layer`: component | language | design | test | workflow
   - `tier`: entry | judgment | mechanical   (default mechanical when absent)
   - `delegates`: list of `{ language|framework: <key>, to: <expert-name> }`
   Examples: `dev-go` -> `layer: language, tier: mechanical, delegates: [{language: go, to: golang-pro}]`;
   `dev-be` -> `layer: component, delegates: [{framework: django, to: django-expert}, {framework:
   fastapi, to: fastapi-expert}, {language: java, to: java-architect}, ...]` (framework +
   language-without-wrapper rows).
2. **Generator** -- `scripts/gen-expert-map.sh` (python3 inside; bash YAML parsing is too fragile):
   walk `skills/*/SKILL.md`, read frontmatter `metadata.delegates`/`layer`, emit the canonical
   `expert-skills-map.md` content deterministically (stable sort) -- the human table sections + the
   machine `text` fenced list of expert names. Prose preamble/notes are preserved between sentinel
   markers (`<!-- GENERATED:START -->` / `<!-- GENERATED:END -->`) so only the generated region is owned.
3. **Lint upgrade** -- extend `scripts/lint-expert-map.sh` (the frozen verification) to: (a) keep the
   existing "every expert name resolves to skills/<name>/SKILL.md" check; (b) NEW: run the generator
   to a temp buffer and `diff` against the committed generated region -- exit 1 on any drift, printing
   the diff. This makes frontmatter the enforced single source.
4. **Populate + regenerate** -- fill frontmatter on the owned skills to match the CURRENT map rows
   exactly (no semantic change to the mapping in this US), run the generator to (re)write the map,
   confirm lint PASS.
5. **Evidence** -- record generator+lint output and a sample diff-on-drift in
   `docs/design-docs/F46/evidence.md`.

## Files to touch
- `.harness/skills-src/skills/dev-*/SKILL.md` -- add `metadata` (layer/tier/delegates), owned skills only
- `.harness/skills-src/skills/{design-*,test-*,check-*}/SKILL.md` -- add `metadata` for rows they own
- `.harness/skills-src/scripts/gen-expert-map.sh` -- new, executable (python3)
- `.harness/skills-src/scripts/lint-expert-map.sh` -- upgrade to enforce frontmatter<->map consistency
- `.harness/skills-src/resources/expert-skills-map.md` -- convert to generated region (sentinels)
- `docs/design-docs/F46/evidence.md`

## Not in scope
- F47 resolver (`harness experts`), F48 hook, F50 projection, F51 openai.yaml/implicit policy -- only
  the `tier` FIELD is introduced here; F51 consumes it.
- Editing vendored expert frontmatter beyond their existing `metadata`.
- Changing the actual mapping semantics (dev-go->golang-pro etc. stay identical) -- pure refactor of
  WHERE the truth lives + lint enforcement.
- Removing inline expert mentions from dev-* prose (separate cleanup; the lint just stops them being
  a second source of truth for the table).

## Risks / unknowns
- **YAML parsing**: must read `metadata.delegates` (nested list) reliably -> use python3 with a tiny
  hand-rolled frontmatter reader (no guaranteed pyyaml); validate.sh requires `name:`+`description:`
  in the first lines -- keep those first, add `metadata:` after.
- **Generated-region sentinels**: validate.sh / depth-lint must still pass on the rewritten map file;
  confirm the fenced `text` block stays parseable by the existing extraction in lint.
- **Determinism**: generator output must be stable (sorted) so re-running yields no diff -> else the
  lint flaps. Self-check: generate twice, assert identical.
- **dev-be 1:many rows**: framework + language-without-wrapper rows are the messiest; model them as a
  flat `delegates` list keyed by `framework:` or `language:` to keep the schema uniform.
