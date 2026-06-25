# Evidence: Suppress implicit skill auto-select for non-entry skills

## What was built
Implicit skill auto-selection is now constrained to the entry-tier spine, so a weak model on Codex or
Antigravity cannot pull craft/expert/component skills out-of-band and bypass the gates.

- **Entry-tier set established** — added `metadata: {layer: workflow, tier: entry}` to
  `workflow-intake`, `workflow-bootstrap`, `workflow-feature`, `workflow-team` (workflow-bugfix
  already had it). The 5 `workflow-*` orchestrators are the only legitimate front-doors; no
  `delegates` were added, so the F46 expert map is unchanged.
- **(a) Codex policy generator** — `scripts/gen-implicit-policy.sh` (python3, same frontmatter reader
  as gen-expert-map) walks `skills/*/SKILL.md`, reads `metadata.tier`, and emits a deterministic
  (sorted) `openai.yaml`: `tier: entry` → `allow_implicit_invocation: true`; everything else
  (judgment / mechanical / **no tier**) → `false`. Default-off is fail-safe — a skill is implicit
  ONLY if it explicitly declares `tier: entry`. Unknown tier values fail loud (exit 2).
  Result: **5 true, 78 false, 83 listed.**
- **Wired into install.sh** — `wire_codex_implicit_policy` writes `<PROJECT_ROOT>/.agents/openai.yaml`
  via the generator (alongside F50's `.agents/skills`). `.agents/openai.yaml` added to the top-level
  install gitignore manifest and the repo `.gitignore`.
- **(b) Antigravity spine** — the existing `wire_antigravity` already generates explicit
  `/name` Workflow adapters (`.agents/workflows/harness-workflow-*.md`) that reference skills by
  name. The spine is therefore invoked explicitly; the test asserts these adapters exist.

## How it was verified
Frozen verification: `bash .harness/skills-src/scripts/test-implicit-policy.sh` → **PASS (23 checks)**.
- **Completeness** — every `skills/*/` dir appears exactly once in the policy (83 == 83); none missing.
- **(a) entry ON** — all 5 `workflow-*` are `allow_implicit_invocation: true`.
- **spot-check OFF** — `dev-be`, `dev-go`, `python-pro`, `react-expert`, `design-api`,
  `check-code-review`, `opt-caveman`, `test-unit`, `ship-deploy`, `core-explore` are all `false`.
- **invariant** — count of `true` (5) equals the count of `tier: entry` skills (5), and every `true`
  line maps to a skill that is actually `tier: entry` (no non-entry skill is ever implicit-on).
- **determinism** — two generator runs are byte-identical.
- **(b) install wiring** (hermetic `HARNESS_PROJECT_ROOT` + `GEMINI_CONFIG_DIR` temp) — `install.sh`
  writes `.agents/openai.yaml` carrying the policy AND the explicit `harness-workflow-*.md` adapters
  for all 5 workflows are present.

Regression: `validate.sh` PASS; F46 `lint-expert-map` PASS (tier change doesn't touch the map); F49
`lint-no-self-eval-gates` PASS; F47 `test-experts-resolver` PASS; F50 `test-cross-host-projection`
PASS. Real self-install (with `~/.gemini` redirected to a temp dir) wrote `.agents/openai.yaml`
correctly, and the artifact is gitignored.

## Test
- test-implicit-policy (frozen) — PASS, exit 0 (23 checks). 5 entry implicit-on, all others off.
- Policy tally: 5 true / 78 false / 83 listed; generator deterministic; unknown tier → exit 2.

## Review
- [x] **R1 — entry set scope.** Limiting `tier: entry` to the 5 `workflow-*` orchestrators is the
  tightest defensible set (AGENTS.md names workflow-intake as THE entry; the others are top-level
  routes). If a host ever needs another implicit front-door, tagging it `tier: entry` makes the
  policy follow automatically. Recorded, intentional.
- [x] **R2 — default-off is fail-safe, not fail-open.** A skill with no tier is implicit-off; the
  worst case is a legitimate entry skill needing explicit invocation, never an unintended skill
  becoming implicitly selectable. The invariant check proves no non-entry skill is ever `true`.
- [x] **R3 — Codex openai.yaml exact shape unknown (no live Codex).** Emitted as a single workspace
  manifest with the `skills:<name>:allow_implicit_invocation` mapping the behavior names; simple YAML,
  easy to adapt. Chose a single manifest over per-skill sidecars to keep the shared canonical skills
  dir pristine (mirrors F50's `.agents/skills.json`).
- [x] **R4 — Antigravity still surfaces all skills via skills.json (F50).** True, but (b)'s mitigation
  is the explicit `/name` Workflow spine plus the fact that Antigravity invokes the spine, not raw
  skills; the openai.yaml policy is the enforcing artifact for Codex where implicit match is the risk.
No open findings remain.

## Key decisions made
- **Tier is the single source of truth for the policy**, consumed exactly as F46 intended; the
  generator never re-derives classification — it reads frontmatter, like the expert map and resolver.
- **Default-off** — only an explicit `tier: entry` grants implicit invocation; the 78 untagged/craft
  skills need no per-skill edit and are safe by construction.
- **Single workspace manifest** (`.agents/openai.yaml`) rather than per-skill sidecars — keeps the
  canonical skills dir unpolluted and mirrors the F50 registry pattern.
- **Reused install.sh env-override + projection pattern** from F50 so the wiring is hermetically
  testable without polluting the real project or home.
