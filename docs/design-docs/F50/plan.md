# Plan: Cross-host skill projection — symlink CC/Codex + skills.json Antigravity

## Behavior to implement
`install.sh` projects the single canonical skills dir (`.harness/skills-src/skills`) into each host's
native discovery WITHOUT content duplication:
- (a) **CC** → symlink `.claude/skills` → canonical dir  *(already implemented; keep)*
- (b) **Codex** → symlink `.agents/skills` → canonical dir  *(NEW — currently a no-op)*
- (c) **Antigravity** → generate `skills.json` with `{"entries":[{"path":"<abs canonical dir>"}]}` —
  workspace `.agents/skills.json` (primary) and global `~/.gemini/config/skills.json` (merge-safe),
  because Antigravity resolves symlinks to absolute paths and its file-walker may skip symlinks, so a
  registry is the robust source.

## Investigation (the MUST-verify)
Question: does Antigravity's default scan of the `.agents/skills` symlink (shared dir with Codex)
skip silently or error hard? I cannot run a live Antigravity build in this environment, so I make the
**robust-by-default** choice that is correct under BOTH outcomes:
- Antigravity sources skills **solely via `skills.json`** (absolute path), never by walking the
  `.agents/skills` symlink. So the symlink serves **Codex only**.
- If a build merely *skips* symlinks → benign (registry still feeds Antigravity).
- If a build *hard-errors* on the symlink's mere presence in `.agents/` → provide an env escape hatch
  `HARNESS_CODEX_SKILLS_LINK` to relocate Codex's symlink out of `.agents/`, keeping Antigravity on
  skills.json. Documented in install.sh + evidence.
This is exactly the "split the path" contingency the behavior specifies, applied as the default.

## Approach
1. **Make projection testable** — in `skills-src/install.sh`, let `PROJECT_ROOT` be overridden by
   `HARNESS_PROJECT_ROOT` (else the existing git-superproject/two-levels-up derivation). Add
   `GEMINI_CONFIG_DIR` (default `$HOME/.gemini`) override for the global registry. Both let the test
   run hermetically into temp dirs while `SKILLS_SRC` stays the real canonical dir.
2. **`wire_codex`** — replace the no-op with a relative symlink `.agents/skills` → canonical skills
   dir (same safe pattern as CC: skip + warn if a real non-symlink dir exists; honor
   `HARNESS_CODEX_SKILLS_LINK` to relocate). Idempotent.
3. **`wire_antigravity_skills`** (new) — write `{"entries":[{"path":"<abs canonical skills dir>"}]}`:
   - workspace `$PROJECT_ROOT/.agents/skills.json` (authoritative, project-scoped);
   - global `$GEMINI_CONFIG_DIR/config/skills.json`, **merge-safe**: preserve existing entries, add
     ours, dedupe by `path` (python3 — no jq dependency for correctness). Idempotent (re-run = no dup).
4. **Wire-up + manifest** — call the new functions in the install sequence; add `.agents/skills` and
   the skills.json paths to the top-level `install.sh` gitignore/projected-paths manifest so the
   generated artifacts are ignored like `.claude/skills`.
5. **Test (frozen verification)** — `scripts/test-cross-host-projection.sh`: run `skills-src/install.sh`
   with `HARNESS_PROJECT_ROOT`=tmp and `GEMINI_CONFIG_DIR`=tmp, then assert:
   - `.claude/skills` and `.agents/skills` are symlinks resolving (realpath) to the canonical
     `skills-src/skills` dir;
   - `.agents/skills.json` and `$GEMINI/config/skills.json` are valid JSON with an `entries[].path`
     that is ABSOLUTE and resolves to the canonical dir;
   - **no content duplication** — neither `.claude/skills` nor `.agents/skills` is a real copied dir
     (both are symlinks; the canonical dir is the only real copy);
   - **idempotency** — a second run leaves the symlinks intact and the global skills.json with exactly
     one entry for our path (no duplicate);
   - **global merge-safety** — a pre-existing unrelated entry in the global skills.json survives.
6. **Evidence** — record the projection output, the resolved targets, the JSON, idempotency + merge
   proof, and the Antigravity investigation decision in `docs/design-docs/F50/evidence.md`.

## Files to touch
- `.harness/skills-src/install.sh` — PROJECT_ROOT/GEMINI overrides; real `wire_codex`; new
  `wire_antigravity_skills`; wire-up + comments documenting the split
- `.harness/skills-src/scripts/test-cross-host-projection.sh` — new, executable (frozen verification)
- `install.sh` (top-level) — add `.agents/skills` + skills.json to the gitignore/projected manifest
- `docs/design-docs/F50/evidence.md`

## Not in scope
- Changing CC's existing `.claude/skills` symlink behavior (keep as-is).
- The workflow-adapter generation (`.agents/workflows/harness-*.md`) — separate concern, untouched.
- F51 implicit-invocation policy.
- Live Antigravity end-to-end run (unavailable here) — the robust split is chosen to be correct
  regardless, with the escape hatch documented.

## Risks / unknowns
- **Antigravity symlink scan behavior** — addressed above via the registry-authoritative split +
  escape hatch; correct under skip-or-error.
- **Global home side effect** — writing `~/.gemini/config/skills.json` touches outside the project;
  mitigated by merge-safe dedup (never clobbers user entries) and `GEMINI_CONFIG_DIR` override so the
  test never pollutes the real home.
- **`set -e` in install.sh** — the new functions must not exit non-zero on benign conditions; guard
  file checks and mkdir.
- **Relative vs absolute** — symlinks stay relative (portable, like CC); skills.json uses absolute
  per the behavior (Antigravity resolves to abs paths).
- **Frozen-verification immutability** — finalize the test assertions before `harness start`.
