# Evidence: harness experts: deterministic skill-chain resolver

## What was built
A deterministic resolver that turns a stack into the exact skill chain to load, with zero model
judgment — a lookup over the SAME single source of truth F46 established (the `metadata.delegates`
frontmatter on the harness skills).

- **Resolver** — `scripts/experts-resolver.sh` (python3 embedded; same frontmatter parser as
  `gen-expert-map.sh`, no pyyaml dep). Builds four indexes from frontmatter — language→wrapper
  (only `layer: language` skills), language→expert, framework→expert, framework→owning-component —
  then resolves:
  - **component** = `dev-<c>` from `--component {be|fe|cli|db|batch}`; else inferred from the
    framework's owning skill (dev-be/dev-fe); else defaults to `dev-be` (logged).
  - **language wrapper** = the `dev-<lang>` wrapper for the language, or **none** for
    languages mapped only under a component skill (Java, C#, Kotlin, PHP, C++, SQL, Swift) — the
    expert then runs directly under the component.
  - **expert** = the framework's expert when a framework is given, else the language's expert.
  - Inputs come from flags (`--language`/`--framework`/`--component`, flags win) or a parsed Stack
    block (`--stack <path>`, default `docs/design/architecture.md`).
- **Output contract** — skill **NAMES** are the cross-host contract (CC Skill tool / Codex
  `$skill` / Antigravity `skills.json`); each name's `skills/<name>/SKILL.md` path is the **FALLBACK**.
  Default `table` format prints `role <TAB> name <TAB> path` (+ `# note:` lines for inferred
  component / missing wrapper); `--format names` prints just the ordered names for hook/script use.
- **Fail loud** — an unknown language/framework, or no stack at all, exits non-zero with a clear
  message rather than guessing. Every emitted name is checked to have a real `SKILL.md` on disk.
- **Stack-block fuzziness** — values carry version noise (`Next.js 15.x`, `Spring Boot 3.x`); the
  resolver strips version tokens + parentheticals, normalizes to alphanumerics, and applies a small
  alias table (`c#`→csharp, `c++`→cpp, `asp.net core`→aspnet, `node`→javascript). Flags match
  delegate keys verbatim (lowercased).
- **Map pointer** — `resources/expert-skills-map.md` gained a one-line prose note (outside the
  GENERATED region) that the resolver is the deterministic consumer of the map.

## How it was verified
Frozen verification: `bash .harness/skills-src/scripts/test-experts-resolver.sh`

`test-experts-resolver.sh` asserts a table of `(args) → expected chain` over every resolution
branch and the cross-cutting guarantees:
- **Branches** — go backend (`dev-be dev-go golang-pro`); django/python (`dev-be dev-python
  django-expert`); react+ts frontend (`dev-fe dev-js-ts react-expert`); java+spring-boot, no wrapper
  (`dev-be spring-boot-engineer`); bare java default-component (`dev-be java-architect`); go CLI
  (`dev-cli dev-go golang-pro`); framework-inferred component (`react` → `dev-fe react-expert`);
  rust backend; sql under db; case-insensitive `--language Go`.
- **Stack-block parity** — a temp `architecture.md` (TypeScript + Next.js 15.x) and a fuzzy one
  (Java + Spring Boot 3.x) resolve identically to the flag form.
- **FALLBACK paths** — every emitted `skills/<name>/SKILL.md` exists on disk.
- **Determinism** — two runs are byte-identical.
- **Fail-loud** — unknown language, unknown framework, and no-input each exit non-zero.

Result: `test-experts-resolver: PASS (17 checks)`, exit 0. Baseline `scripts/validate.sh` →
`== validate: PASS ==`; `scripts/lint-expert-map.sh` → `PASS (36 experts; map in sync with
frontmatter)` (the F46 map source is untouched).

## Key decisions made
- **The script IS the resolver; the `harness` binary is not modified.** The binary is a separate
  release (`nobodyonlyc/harness`) and cannot be rebuilt in this repo. The frozen verification targets
  the script, matching how F46 shipped its generator/lint as scripts. Wiring a `harness experts`
  binary subcommand that shells out to `scripts/experts-resolver.sh` is a follow-up in the harness
  repo — recorded, not done. Name-as-contract / path-as-fallback is honored regardless of caller.
- **Read F46's frontmatter, don't duplicate the mapping.** The resolver and the map generator share
  one parser and one source of truth; adding a delegate row automatically extends the resolver. No
  second place to keep in sync.
- **`layer: language` is what distinguishes a wrapper from a component-hosted language.** Java/C#/etc.
  carry `language:` delegates under `dev-be` (a `layer: component` skill), so they correctly resolve
  to "no wrapper" — the expert runs under the component.
- **Flags exact, Stack block fuzzy.** The hook/F48 and agents pass delegate keys via flags (exact,
  lowercased); the human-authored Stack block needs version/spelling tolerance, isolated to the
  Stack-parsing path so flag resolution stays unambiguous.
- **Default component = dev-be, but logged.** A bare backend language with no framework is ambiguous;
  the resolver defaults to `dev-be` and emits a `# note:` rather than silently picking, so the
  assumption is visible.
