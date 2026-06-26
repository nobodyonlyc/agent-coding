# Evidence: M3 review-provenance gate

## What was built
- `hooks/review-provenance-gate.sh` — a PreToolUse(Bash) HARD gate. On `harness verify <id>` it
  queries `harness review status <id> --json` and blocks unless `state == CURRENT`:
  - `NONE` (no independent review recorded) → block with remediation (role-resolver → review
    open/record).
  - `STALE` (working tree changed since the review) → block, ask to re-review.
  - `--override-snapshot` → bypass (explicit intent), mirroring the verify snapshot / review-fix
    gates.
  - Fail-open where it cannot positively decide: no harness binary, or a binary predating the
    `review` subcommand → exit 0 (never false-block a harness without the new CLI).
- Wired into `config-templates/claude.settings.json` (PreToolUse→Bash, after review-fix-gate) and
  `config-templates/antigravity.hooks.json` (PreToolUse→run_command).
- `scripts/test-review-provenance-gate.sh` — the frozen F53 verification.

This is the EXECUTION-grade half of review enforcement: provenance is stamped by the CLI and bound
to the git diff (H-M2), so it cannot be forged by writing text into evidence.md — unlike the
complementary textual review-gate / review-fix-gate, which it sits alongside.

## How it was verified
Verification command: `bash .harness/skills-src/scripts/test-review-provenance-gate.sh` →
**6 passed, fail=0**. The test builds a throwaway harness project (real binary + git repo) and
asserts hook exit codes: non-verify command allowed; verify with NONE blocked; after open+record
(CURRENT) allowed; after a tracked edit (STALE) blocked; `--override-snapshot` bypass allowed;
fail-open (no binary reachable) allowed. Both JSON config templates re-validated with `json.load`.

## Key decisions made
- **Fail-open on capability gaps, fail-closed on a positive bad verdict.** False-blocking every
  `harness verify` in an environment with an old binary would break the harness; the gate enforces
  only where the new CLI is present. Recorded as the honest limit.
- **Reads `review status --json`, not sqlite directly.** Keeps the gate host-agnostic (no sqlite3
  dependency); the binary owns provenance parsing.
- **STALE blocks, `--override-snapshot` bypasses.** Same escape hatch and philosophy as the
  existing verification-snapshot guard, so the behavior is already familiar.
- **Not wired into the live `.claude/settings.json` mid-epic** (only into the templates). Wiring it
  live now would block F54/F55's own verifies before the spawn+record flow exists; the final
  install.sh re-run activates it. Documented in the plan.

## Review
- [x] Self-review of the diff. Checked: the command-match guard only triggers on `harness verify`
  (non-verify allowed — tested); feature-id extraction reuses the proven review-fix-gate sed;
  fail-open branches verified (no binary, old binary, no python3 all exit 0); positive NONE/STALE
  both exit 1 (tested); JSON templates parse. No open findings.
- [x] Independent-reviewer spawn deferred to F54; this gate is what makes that spawn enforceable
  once wired live.
