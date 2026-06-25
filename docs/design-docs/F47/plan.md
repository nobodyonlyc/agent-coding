# Plan: harness experts: deterministic skill-chain resolver

## Behavior to implement
A deterministic resolver that, given a stack (language + optional framework + component), prints the
exact skill chain to load — **component skill → language wrapper → vendored expert** — as skill
NAMES (the contract) plus each name's relative `skills/<name>/SKILL.md` path (the FALLBACK). Zero LLM
judgment: a weak model reads the resolver output instead of inferring the mapping. Resolution is a
table lookup over the SAME single source of truth F46 established — the `metadata.delegates`
frontmatter on the harness skills.

Input is either explicit flags (`--language`, `--framework`, `--component`) or a Stack block file
(`--stack <path>`, default `docs/design/architecture.md`) from which `language:` / `framework:` are
parsed. `--component {be|fe|cli|db|batch}` (or inferred from the framework's owning skill).

## Approach
1. **Resolver script** — `scripts/experts-resolver.sh` (python3 embedded, mirroring
   `gen-expert-map.sh` so both read frontmatter the same way; no pyyaml dep). It:
   - Reuses the frontmatter `metadata.delegates` parser to build an index of rows
     `(harness_skill, kind∈{language|framework|trigger}, key, label, expert)`.
   - Reads inputs: flags win; otherwise parse the Stack block (`## Stack (machine-readable)` →
     `- language:` / `- framework:` lines, taking the first token of the value, lowercased).
   - **Resolves the chain deterministically:**
     - `component` skill = `dev-<component>` from `--component`; else inferred from the framework
       row's owning harness skill (dev-be/dev-fe); else defaults to `dev-be` for a bare backend
       language (logged as the default).
     - `language wrapper` = the `layer: language` harness skill whose `language:` delegate key
       matches (dev-go/dev-python/dev-js-ts/dev-rust). Languages with no dedicated wrapper
       (Java, C#, Kotlin, PHP, C++, SQL, Swift) resolve to **none** — expert is invoked directly
       under the component skill.
     - `expert` = framework row's expert when a framework is given; else the language row's expert.
   - **Emits** the chain (default human+machine `role<TAB>name<TAB>path` lines with a header; a
     `--format names` mode prints just names, one per line, for hook/script consumption). Unknown
     language/framework → non-zero exit with a clear "not in map; run gen-expert-map" message
     (fail loud, never guess).
2. **Test** — `scripts/test-experts-resolver.sh` (the FROZEN verification): a table of
   `(args) → expected chain` cases covering every resolution branch:
   - language-with-wrapper backend: `--language go --component be` → `dev-be dev-go golang-pro`
   - framework + language: `--language python --framework django --component be`
     → `dev-be dev-python django-expert`
   - frontend framework: `--language typescript --framework react --component fe`
     → `dev-fe dev-js-ts react-expert`
   - language-without-wrapper: `--language java --framework spring-boot --component be`
     → `dev-be spring-boot-engineer` (no wrapper line)
   - Stack-block parsing: a temp `architecture.md` with a Stack block resolves identically to flags.
   - FALLBACK paths: every emitted name has a `skills/<name>/SKILL.md` that exists on disk.
   - Determinism: two runs byte-identical. Unknown input: non-zero exit.
3. **Map note** — add a short pointer in `resources/expert-skills-map.md` (hand-prose region, not the
   generated region) that the resolver is the deterministic consumer of this map.
4. **Evidence** — record resolver output for each branch + the frozen test PASS in
   `docs/design-docs/F47/evidence.md`.

## Files to touch
- `.harness/skills-src/scripts/experts-resolver.sh` — new, executable (python3 embedded)
- `.harness/skills-src/scripts/test-experts-resolver.sh` — new, executable (the frozen verification)
- `.harness/skills-src/resources/expert-skills-map.md` — one-line prose pointer (outside GENERATED region)
- `docs/design-docs/F47/evidence.md`

## Not in scope
- **Modifying the `harness` binary** — it is a separate release (`nobodyonlyc/harness`) and cannot be
  rebuilt here. The script IS the resolver; wiring a `harness experts` binary subcommand that shells
  out to it is a follow-up in the harness repo. Documented, not done.
- F48 hook injection (consumes this resolver), F50 projection, F51 implicit policy.
- Changing the mapping semantics or the frontmatter schema (read-only consumer of F46's source).

## Risks / unknowns
- **Stack-block value parsing** — values carry version noise (`Next.js 15.x`, `Node.js 22.x (LTS …)`).
  Normalize by taking a slug of the framework/language name (lowercase, strip version/punctuation) and
  matching against delegate keys; keep a small alias map (e.g. `next.js`→`next.js` key, `nodejs`/`node`
  → typescript/javascript handled via the explicit `language:` line). Prefer the explicit `language:`
  line for the wrapper; use `framework:` only for the expert.
- **Component inference** — a bare language with no framework and no `--component` is ambiguous; default
  to `dev-be` and LOG the assumption rather than silently guessing a frontend.
- **Determinism** — output must be stable; no time/random; sort nothing that affects a single chain.
- **Frozen-verification immutability** — the test is the verification and is locked after `start`;
  write the case table completely before starting so it never needs editing.
