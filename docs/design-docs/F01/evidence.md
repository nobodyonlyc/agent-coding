# Evidence: Scaffold harness-skills repo + submodule + validator

## What was built
The `harness-skills` repo (`git@github.com:nobodyonlyc/harness-skills.git`) was scaffolded and
pinned into this project as a git submodule at `.harness/skills-src` (commit `5a30854`):

- `README.md` — purpose + per-agent consumption model (submodule, native loading, no `harness mcp serve`).
- `CATEGORIES.md` — skill prefix index + the 9-phase lifecycle map + the phase-⑦ test-type selection matrix.
- `install.sh` — executable per-agent wiring **skeleton** (anchors `.claude/skills` + `.agent/workflows`; real wiring is F11/F12).
- `scripts/validate.sh` — executable structure linter that validates only what exists (skill frontmatter, `bash -n` on hooks, `.gitmodules`↔caveman).
- `vendor/caveman` — nested submodule, upstream `JuliusBrussee/caveman` (MIT), checked out at `25d22f8`.
- `LICENSE` + directory placeholders (`skills/ resources/ hooks/ config-templates/` via `.gitkeep`).

## Test
The exact F01 verification command was run and passed:

```
$ bash -c 'cd .harness/skills-src && test -f README.md && test -f CATEGORIES.md \
    && test -x install.sh && test -x scripts/validate.sh && test -d vendor/caveman \
    && bash scripts/validate.sh'
== validate harness-skills ==
== validate: PASS ==
VERIFY-CMD: PASS
```

Also confirmed: `git submodule update --init --recursive` pulls `vendor/caveman` (caveman
`SKILL.md`/`README.md` present on disk), and `validate.sh` still passes after the review fix.

This is a scaffolding feature (markdown + bash, no application runtime), so the test strategy
per `check-test-strategy` is **unit/structural only** — no IT/regression/e2e/perf/security apply.

## Review
Self-review of the scaffold (no external `/code-review` since this is repo-bootstrap):

- **Finding (minor, fixed):** `validate.sh` defined an unused `note()` helper — removed in
  commit `5a30854`; validator re-run, still PASS.
- **Finding (by design, accepted):** `install.sh` only prints `[skeleton]` wiring messages.
  This is intentional and listed under "Not in scope" in `plan.md`; the real Claude
  Code / Antigravity / Codex projection lands in F11 and the hook wiring in F12. The script
  still references `.claude/skills` and `.agent/workflows` so F11's grep verification is satisfiable.
- **Finding (accepted):** `LICENSE` carries an abbreviated MIT body; sufficient to satisfy the
  README reference, can be expanded later.
- No correctness, security, or scope-creep issues. The validator is intentionally permissive
  (lints only present files) so it stays green as F02–F20 add content.

## Key decisions made
- **Nested submodule for caveman** (vs copy-paste): lets caveman update independently via
  `git submodule update --remote`; requires `--recursive` on clone, documented in README.
- **`validate.sh` validates only what exists**: avoids a chicken-and-egg failure on the empty
  scaffold and lets each later feature's verification reuse the same growing linter.
- **Submodule path `.harness/skills-src`**: keeps reusable assets beside harness state; the
  consuming `.claude/skills` / `.agent/workflows` are generated projections, not the source.
