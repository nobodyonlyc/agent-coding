# Evidence: Cross-host skill projection — symlink CC/Codex + skills.json Antigravity

## What was built
`skills-src/install.sh` now projects the single canonical skills dir (`.harness/skills-src/skills`)
into every host's native discovery with NO content duplication:
- **CC** — `.claude/skills` relative symlink → canonical dir (pre-existing; kept).
- **Codex** — `.agents/skills` relative symlink → canonical dir (`wire_codex`, previously a no-op).
  Honors `HARNESS_CODEX_SKILLS_LINK` to relocate the symlink out of `.agents/` if ever needed.
- **Antigravity** — `wire_antigravity_skills` writes a `skills.json` registry
  `{"entries":[{"path":"<abs canonical dir>"}]}` to both the workspace (`.agents/skills.json`,
  authoritative) and the global config (`<GEMINI_CONFIG_DIR>/config/skills.json`, default
  `~/.gemini`). The global write is **merge-safe**: existing entries are preserved and deduped by
  `path` (python3, no jq dependency).

Supporting changes: `PROJECT_ROOT` is overridable via `HARNESS_PROJECT_ROOT` and canonicalized with
`pwd -P` (so relative symlinks resolve even under a symlinked root like macOS `/tmp`→`/private/tmp`);
`GEMINI_CONFIG_DIR` is overridable so tests never touch the real home. The top-level `install.sh`
gitignore manifest and the repo `.gitignore` now ignore `.agents/skills` and `.agents/skills.json`
alongside `.claude/skills`.

## Investigation — Antigravity scan of the shared `.agents/skills` symlink
The behavior requires verifying whether Antigravity's default scan of the `.agents/skills` symlink
(a dir it shares with Codex) skips silently or errors hard. A live Antigravity build is unavailable
in this environment, so I implemented the **robust-by-default** split that is correct under BOTH
outcomes: Antigravity sources skills **solely via `skills.json`** (absolute path), never by walking
the symlink, so the symlink serves **Codex only**. If a build merely skips symlinks → benign; if a
build hard-errors on the symlink's presence → the `HARNESS_CODEX_SKILLS_LINK` escape hatch relocates
Codex's symlink out of `.agents/` while Antigravity stays on the registry. This is exactly the
"split the path" contingency, applied pre-emptively.

## How it was verified
Frozen verification: `bash .harness/skills-src/scripts/test-cross-host-projection.sh` → **PASS
(17 checks)**. It runs `install.sh` against a hermetic temp `HARNESS_PROJECT_ROOT` + `GEMINI_CONFIG_DIR`
and asserts:
- `install.sh` exits 0;
- `.claude/skills` and `.agents/skills` are **symlinks** whose realpath equals the canonical dir;
- **no duplication** — both projections are symlinks, not copied directories;
- `.agents/skills.json` is valid JSON whose `entries[0].path` is **absolute** and resolves to the
  canonical dir;
- the global `skills.json` is valid JSON, has **exactly one** canonical entry, and **preserves** a
  pre-seeded unrelated entry (`/opt/other/skills`) — merge-safety;
- **idempotency** — a second run keeps the Codex symlink intact, adds no duplicate canonical entry,
  and still preserves the pre-seeded entry.

## Test
- test-cross-host-projection (frozen) — PASS, exit 0 (17 checks).
- **Real self-install** (`GEMINI_CONFIG_DIR` redirected to a temp dir so the real `~/.gemini` is not
  touched): created `.agents/skills` → `../.harness/skills-src/skills`, kept `.claude/skills`, and
  wrote `.agents/skills.json` with the absolute canonical path
  `/Users/zrik/workspace/projs/agent-coding/.harness/skills-src/skills`. The new artifacts are
  correctly gitignored (not shown by `git status`).
- Baseline `scripts/validate.sh` → `== validate: PASS ==`.

## Review
- [x] **R1 — relative-symlink resolution under symlinked roots.** macOS `/tmp`→`/private/tmp` first
  broke target resolution; fixed by canonicalizing `PROJECT_ROOT` with `pwd -P`. This also hardens
  real installs under any symlinked path. CC's existing symlink behavior is unchanged.
- [x] **R2 — global home side effect.** `~/.gemini/config/skills.json` is written merge-safe (never
  clobbers user entries) and is fully overridable via `GEMINI_CONFIG_DIR`; the test proves a
  pre-existing entry survives, and the real-install verification redirected it to a temp dir.
- [x] **R3 — Antigravity symlink scan unknown.** Resolved by the registry-authoritative split +
  escape hatch (see Investigation); correct whether the scan skips or errors.
- [x] **R4 — no content duplication.** Asserted: both projections are symlinks; the canonical dir is
  the only real copy. Out-of-scope note: running the installer regenerated the tracked, previously
  stale `.agents/hooks.json` (it had not been refreshed since the F48 template change); committed
  separately as a projection resync, not folded into F50.
No open findings remain.

## Key decisions made
- **One canonical dir, three projections, zero copies.** Symlinks for CC/Codex; a registry for
  Antigravity. Editing a skill edits one file; every host sees it immediately.
- **Registry is authoritative for Antigravity, symlink is Codex-only.** This makes the shared
  `.agents/` path safe regardless of how Antigravity treats symlinks, and matches the behavior's
  contingency without needing a live test.
- **Testability via env overrides** (`HARNESS_PROJECT_ROOT`, `GEMINI_CONFIG_DIR`) keeps the frozen
  verification hermetic — no pollution of the real project or home — while exercising the real
  `install.sh` code path (not a reimplementation).
- **python3 for the registry merge** — deterministic dedupe-by-path with no jq dependency, mirroring
  the project's existing python-in-bash pattern (gen-expert-map, expert-inject).
