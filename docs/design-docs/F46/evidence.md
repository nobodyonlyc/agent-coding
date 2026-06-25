# Evidence: Declarative skill map via frontmatter + generated expert-skills-map

## What was built
Frontmatter is now the **single source of truth** for the harness→expert delegation map.

- **Schema** — 14 owned harness skills gained a `metadata:` block with `layer`, `tier`
  (entry|judgment|mechanical), and a `delegates:` list of `{language|framework|trigger: <key>,
  label?: <human>, to: <expert>}`. Skills: `dev-go`, `dev-python`, `dev-js-ts`, `dev-rust`,
  `dev-be`, `dev-fe`, `dev-db`, `dev-cli`, `test-unit`, `test-e2e`, `design-api`,
  `design-architecture`, `check-code-review`, `workflow-bugfix`. Vendored experts were NOT edited.
- **Generator** — `scripts/gen-expert-map.sh` (python3 embedded): walks `skills/*/SKILL.md`, reads
  `metadata.delegates`, and emits the GENERATED region of `resources/expert-skills-map.md` (3 tables
  + the machine-checked fenced expert list), deterministically (stable sort). `--write` rewrites the
  region between sentinels; no-arg prints it for diffing.
- **Lint upgrade** — `scripts/lint-expert-map.sh` now enforces three things: (1) CONSISTENCY — the
  committed region equals the generated region (fails with a diff on drift); (2) RESOLUTION — every
  listed expert resolves to `skills/<name>/SKILL.md`; (3) DETERMINISM — two generator runs are
  identical.
- **Map** — `resources/expert-skills-map.md` converted: hand-maintained tables replaced by a
  generated region delimited by `<!-- GENERATED:START/END -->`; preamble + the no-wrapper note stay
  hand-maintained prose. All 36 vendored experts present.
- `tier` is introduced here but consumed later by **F51** (per-host implicit-invocation policy);
  `delegates`/`layer`/`language` is what **F47**'s resolver will read.

## How it was verified
Frozen verification: `bash .harness/skills-src/scripts/lint-expert-map.sh`

## Test
- **lint-expert-map (frozen)** — PASS: `lint-expert-map: PASS (36 experts; map in sync with
  frontmatter)`, exit 0 (direct run).
- **Generator coverage** — emits exactly 36 data rows and 36 unique experts (no noise from vendored
  experts' own `metadata`, which have no `delegates`).
- **Drift negative test** — deleted the `dev-go | Go | golang-pro` row from the committed map; lint
  correctly FAILED with a diff (`12a13 > | `dev-go` | Go | `golang-pro` |`) and the fix hint; after
  restore, PASS again.
- **Determinism** — lint's two-run equality check passes; generator is portable (runs identically
  from an unrelated CWD via absolute path).
- **Baseline** — `scripts/validate.sh` → `== validate: PASS ==`.

## Review
- [x] **R1 — residual expert mentions in `stack-defaults.md`.** Rule 1 (app-type → default stack →
  convention/expert) still names experts. Resolution: that table is a *different* mapping
  (app-type defaults, prose) and is **not** machine-parsed, so it is not a competing source of truth
  for the harness→expert map; the new lint guards the one machine source. Out of scope for F46 per
  plan (inline/prose cleanup is a separate concern). Recorded as a follow-up candidate.
- [x] **R2 — generator portability.** Verified it resolves its own ROOT and runs from any CWD.
- [x] **R3 — parser noise from experts' frontmatter.** Verified vendored experts (which have
  `metadata` with commas) produce zero spurious rows because they declare no `delegates`.
- [x] **R4 — lint exit code.** Direct run returns exit 0 on success, 1 on drift.
No open findings remain.

## Key decisions made
- **Truth lives on the harness skill we own, not the vendored expert.** Experts are third-party MIT
  and keep their own frontmatter untouched; the delegation is declared on the consuming harness
  skill, so re-vendoring an expert never disturbs the map.
- **Generated region + sentinels** rather than generating the whole file — preserves human prose
  (how-to-use, no-wrapper note) while making only the data machine-owned.
- **python3 embedded in the .sh** (no pyyaml dependency) — a tiny hand-rolled frontmatter reader
  keeps the verification a single portable script.
- **Pre-existing, out of scope:** `dev-go` fails `lint-depth` (`no Gate:` / no example) on the
  committed version too — a body-content gap unrelated to this frontmatter change; not touched (scope
  discipline).
