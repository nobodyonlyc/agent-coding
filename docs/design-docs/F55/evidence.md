# Evidence: M5 SubagentStop provenance hook + tests + docs

## What was built
- `hooks/review-record-reminder.sh` — a Claude `SubagentStop` advisory hook. After a subagent stops
  during an in-progress feature, it queries `harness review status <id> --json` and, only when state
  is not CURRENT, injects a `system-reminder` telling the agent to `harness review record …` (or
  re-review if STALE). It NEVER fabricates a verdict (a hook can't review) and always exits 0. Silent
  when no feature is active or provenance is already CURRENT.
- Wired into `config-templates/claude.settings.json` under a new `SubagentStop` event (Claude-only;
  Antigravity/Codex rely on the in-skill CLI instructions from F54).
- `scripts/test-subagent-provenance.sh` — the frozen F55 verification.
- Docs: `README.md` gained a "role-based, provable review" design principle; `docs/review-provenance.md`
  records the full mechanism, the test↔review symmetry table, and the honest limits.

## How it was verified
Verification command: `bash .harness/skills-src/scripts/test-subagent-provenance.sh` → **8 passed,
fail=0**. Part A (reminder hook): silent with no in-progress feature; emits the record reminder
(incl. the `harness review record FT9` command) when provenance is NONE; silent again once CURRENT;
always exits 0. Part B (end-to-end): `role-resolver --phase review --language go` produces a Tech
Lead spec → `harness review open --role <spec>` prints a nonce → `record` → `status --json` reports
CURRENT — proving role→open→record→status compose. `claude.settings.json` re-validated with
`json.load`; repo `validate.sh` PASS.

## Key decisions made
- **Remind, don't fabricate.** The hook cannot know the reviewer's verdict, so auto-recording would
  be unsound. The honest ceiling is a nudge; the execution-grade enforcement stays the F53 gate.
  (Same limit expert-inject documents: a hook can name the obligation, not perform the judgment.)
- **SubagentStop is Claude-only.** Antigravity has no equivalent event; its path is the CLI calls
  the F54 skills already prescribe. Documented rather than faked.
- **End-to-end test ties the pieces.** F52/F53 test units in isolation; F55 proves the role spec
  actually feeds the CLI and flips the gate state — the integration the user asked for.

## Review
- [x] Self-review of the diff. Checked: hook is advisory (exit 0 on every path, verified by the
  test); it stays silent when CURRENT/no-feature (no nag spam); reminder text contains an actionable
  command; SubagentStop JSON wiring parses; docs are accurate to the implementation. No open
  findings.
- [x] Epic closeout (activate live gate via install.sh + deploy binary to consumers) is tracked as
  the post-F55 step, intentionally after this verify to avoid the gate blocking the epic's own US.
