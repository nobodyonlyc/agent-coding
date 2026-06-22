# Plan: Scaffold harness-skills repo + submodule + validator

## Behavior to implement
harness-skills exists as submodule at .harness/skills-src with README, CATEGORIES.md, install.sh, scripts/validate.sh and caveman vendored via .gitmodules; validator passes.

## Approach
1. Work inside a local clone of the (near-empty) `harness-skills` remote and lay down the
   canonical structure that every later feature fills in:
   - `README.md` — what the repo is, how it is consumed (git submodule, native per-agent loading, no `harness mcp serve`).
   - `CATEGORIES.md` — the skill index: prefixes (`workflow-/plan-/design-/dev-/check-/test-/ship-/core-/opt-`) and the 9-phase lifecycle map.
   - `install.sh` — executable entry point (skeleton in F01; real per-agent wiring lands in F11/F12). Must already reference `.claude/skills` and `.agent/workflows` so its grep-based verifications are satisfiable later.
   - `scripts/validate.sh` — executable structure linter that grows with the repo: validates only what exists (frontmatter on every `skills/*/SKILL.md`, `bash -n` on every `hooks/*.sh`), so it stays green from an empty tree onward.
   - directory placeholders: `skills/`, `resources/`, `hooks/`, `config-templates/` (kept via `.gitkeep`).
2. Vendor caveman as a **nested git submodule** at `vendor/caveman` (upstream
   `JuliusBrussee/caveman`, MIT) via `.gitmodules` — independent updates, no copy-paste.
3. Commit + push `harness-skills`.
4. In this project, add it as a submodule: `git submodule add <remote> .harness/skills-src`
   then `git submodule update --init --recursive` to pull caveman too.
5. Run F01 verification (existence + `validate.sh`).

## Files to touch
- In submodule `harness-skills`: `README.md`, `CATEGORIES.md`, `install.sh`, `scripts/validate.sh`, `.gitmodules`, `vendor/caveman` (submodule), `.gitkeep` under `skills/ resources/ hooks/ config-templates/`.
- In this repo: `.gitmodules` (adds `.harness/skills-src`), `.harness/skills-src` gitlink, `docs/design-docs/F01/evidence.md`.

## Not in scope
- Any actual skill, resource, hook, or per-agent wiring content (those are F02–F20).
- `validate.sh` enforcing rules for files that do not exist yet — it lints only present files.
- Touching the `harness` binary or settings.json hook wiring (F12).

## Risks / unknowns
- Nested submodule (caveman inside harness-skills inside this repo) needs `--recursive`;
  document it in README so clones don't end up with an empty `vendor/caveman`.
- Pushing to `harness-skills` overwrites the 16-byte placeholder README — confirmed remote
  has only that one file, so no real content is lost.
- SSH push access to `git@github.com:nobodyonlyc/harness-skills.git` must be available here;
  if push fails, stop and surface it rather than faking the submodule.
