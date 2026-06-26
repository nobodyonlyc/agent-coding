# Plan: M3 review-provenance gate: block verify without valid provenance

## Behavior to implement
A PreToolUse(Bash) hook `hooks/review-provenance-gate.sh` blocks `harness verify <id>` unless
`harness review status <id> --json` reports `state == CURRENT` — i.e. an independent review
provenance exists AND its diff-hash still matches the working tree. `NONE` (no review) and `STALE`
(code changed since the review) both block. `--override-snapshot` bypasses (explicit intent),
mirroring the existing snapshot/review gates. Wired for Claude Code + Antigravity.

## Approach
- `hooks/review-provenance-gate.sh`: mirror `review-fix-gate.sh` structure — read the command from
  `CLAUDE_TOOL_INPUT_COMMAND`/`TOOL_CALL_INPUT`/`$*`, return early unless it is `harness verify`,
  honor `--override-snapshot`, extract the feature id with the same sed.
- **Fail-open on capability gaps, fail-closed on a positive bad verdict.** Locate the harness
  binary (`./harness`, `$CLAUDE_PROJECT_DIR/harness`, PATH); if none, or if the binary predates the
  `review` subcommand (status errors / empty), exit 0 (do NOT false-block environments on an old
  binary). Only block when status positively says NONE or STALE.
- Parse `state` from the JSON with python3 (already a hard dep of other hooks/resolvers).
- Wiring: add the hook to `config-templates/claude.settings.json` (PreToolUse→Bash, after
  review-fix-gate) and `config-templates/antigravity.hooks.json` (PreToolUse→run_command).
- `scripts/test-review-provenance-gate.sh` (F53 verification): build a temp git repo, init harness
  with the real binary (`$ROOT/../../harness`), add a feature, and assert hook exit codes for:
  NONE→block, after open+record→CURRENT→allow, after a tracked edit→STALE→block, --override-snapshot
  →allow, a non-verify command→allow, and old-binary/absent→fail-open allow.

## Files to touch
- `hooks/review-provenance-gate.sh` — NEW (executable).
- `config-templates/claude.settings.json` — add the hook to PreToolUse Bash chain.
- `config-templates/antigravity.hooks.json` — add the hook to PreToolUse run_command chain.
- `scripts/test-review-provenance-gate.sh` — NEW (the F53 verification).

## Not in scope
- Adding the hook to the *live* `.claude/settings.json` of this repo mid-session (that is an
  install-time concern handled by re-running install.sh at the end of the epic; doing it now would
  block this epic's own subsequent verifies before F54 wires the spawn+record flow).
- The per-phase spawn + record calls in skills/workflows (F54).

## Risks / unknowns
- Auto-checkpoint: `harness verify` commits on success, which empties `git diff HEAD` → a later
  verify would see STALE. The gate runs BEFORE verify (pre-checkpoint), so within one feature the
  reviewed diff still matches. Manual commits between review and verify will read STALE → bypass
  with --override-snapshot. Documented.
- Fail-open weakens enforcement where the new binary is absent; chosen over false-blocking the
  whole harness. Recorded as the honest limit.
